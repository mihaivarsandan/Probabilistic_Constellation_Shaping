/*
% Copyright (c) 2015, Patrick Schulte, Georg Böcherer
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation 
%    and/or other materials provided with the distribution.
%
% 3. Neither the name of the copyright holder nor the names of its contributors may
%    be used to endorse or promote products derived from this software without 
%    specific prior written permission.
%
% 4. In case results are published that rely on this source code, please cite
%    our paper entitled "Constant Composition Distribution Matching" [1]. 
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
% IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
% NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
% OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
% [1] http://arxiv.org/abs/1503.05133
*/

//#include <iostream>
//#include <fstream>
#include <vector>
#include <list>
#include <math.h>
#include <matrix.h>
#include <mex.h>


struct codeCandidate{
  double upperBound;
  double lowerBound;
  double probability;
  std::list <int> symbols;

};

struct sourceInterval{
  double upperBound;
  double lowerBound;
};

struct codeCandidateList{
  std::list <struct codeCandidate> list;
  int k;
};


double nchoosek_log2(int n, int k) {
  int i;
  double nck = 0;
  if(k>n-k)
    k = n-k;
  for(i = 1; i<=k; i++){
    nck += log((n-((double)(k-i)))/i)/log(2.0);
  }
  return nck;
}

double nchooseks_log2(int n, int *k, int k_num) {
  int i;
  double ncks = 0;
  for(i = 0; i<k_num; i++){
    ncks += nchoosek_log2(n,k[i]);
    n -= k[i];
  }
  return ncks;
}


void updateSrcInterval(struct sourceInterval *src_Interval, double srcProbability[], int src_symbols){
	double newborder = src_Interval->lowerBound + (src_Interval->upperBound - src_Interval->lowerBound) * srcProbability[0];
	if (src_symbols == 0){
		src_Interval->upperBound = newborder;
	}
	else{
		src_Interval->lowerBound = newborder;
	}
}

int findIdentifiedCodeCandidateIndex(struct sourceInterval src_interval, struct codeCandidateList ccList, int n_i[]){
	int i = 0;
	for (std::list<struct codeCandidate>::iterator it = ccList.list.begin(); it != ccList.list.end(); ++it)
	{
                struct codeCandidate cc = *it;
                if(src_interval.lowerBound <= cc.lowerBound  && cc.lowerBound < src_interval.upperBound && n_i[i] != 0)
			return i;
		i++;
	}
	return -1;
}

/* updates 1-based symbols. functionality works.*/
void updateN_i (int n_i[], std::list<int> list)
{
	int symbolnum;
	for (std::list<int>::iterator it = list.begin(); it != list.end(); ++it)
	{
		symbolnum = *it;
		n_i[symbolnum-1] = n_i[symbolnum-1] -1;
	}
	return;
}

void updateCodeCandidates(struct codeCandidateList *ccList, int n_i[])
{
    ccList->list.erase(ccList->list.begin(), ccList->list.end());
    int n = 0;
    int k = ccList->k;
    double sum_p_i = 0;
    double *p_i;
    p_i = (double*) malloc(sizeof(double)*k);
    for (int i=0;i<k;i++)
    {
            n += n_i[i];
    }
    for(int i=0;i<k;i++)
    {
            struct codeCandidate cc_push;
            p_i[i] = (double)(n_i[i])/(double)(n);
            cc_push.lowerBound = sum_p_i;
            sum_p_i += p_i[i];
            if(i == k-1){
                    cc_push.upperBound = 1.0; /* sum_p_i != 1 migh be true for numerical issues*/
            }
            else{cc_push.upperBound = sum_p_i;}
            cc_push.upperBound = sum_p_i;
            cc_push.probability = p_i[i];
            cc_push.symbols.push_back(i+1);
            ccList->list.push_back(cc_push);
    }
    free(p_i);
}

struct sourceInterval findCodeIntervalFromCandidates(struct codeCandidateList ccList, std::list<int> *searchList){
	std::list<int> cmpList;
	struct sourceInterval code_interval;
	for(std::list<struct codeCandidate>::iterator it = ccList.list.begin() ; it != ccList.list.end(); ++it)
	{
		cmpList = it->symbols;
		if (cmpList == *searchList)
		{
			code_interval.lowerBound = it->lowerBound;
			code_interval.upperBound = it->upperBound;
			searchList->erase(searchList->begin(),searchList->end());
		}
	}
	return code_interval;
}


std::list<int> finalizeCodeSymbols(struct sourceInterval src_interval, struct codeCandidateList ccList,int n_i[]){
	int k = ccList.k;
	int cc_index = findIdentifiedCodeCandidateIndex(src_interval,ccList,n_i);
	if (cc_index == -1)
	{
		std::list<int> emptyList;
		return emptyList;
	}
	std::list<struct codeCandidate>::iterator it= ccList.list.begin();
	std::advance(it,cc_index);
	struct codeCandidate cc = *it;
	std::list<int> symbols_new = cc.symbols;
	updateN_i(n_i,cc.symbols);
	for(int i = 0; i < k; i++){
		for(int j = 0; j < n_i[i];j++){
			symbols_new.push_back(i+1);
		}
	}
	return symbols_new;
}



std::list<int> checkForOutputAndRescale(struct sourceInterval *src_interval, struct codeCandidateList *ccList, int n_i[]){
	int k = ccList->k;
	double *p_i;
	p_i = (double*) malloc(sizeof(double)*k);
	struct codeCandidate cc;
	std::list<int> code_symbols_new;
	int success = 0;
	/* check if output is possible*/
	for(std::list<struct codeCandidate>::iterator it = ccList->list.begin(); it != ccList->list.end(); ++it){
		cc = *it;
		if(src_interval->lowerBound >= cc.lowerBound && src_interval->upperBound <= cc.upperBound){
			success = 1;
			/* right cc chosen */
			break;
		}
	}


	while(success)
	{

		src_interval->lowerBound = (src_interval->lowerBound - cc.lowerBound) / (cc.upperBound-cc.lowerBound);
		src_interval->upperBound = (src_interval->upperBound - cc.lowerBound) / (cc.upperBound-cc.lowerBound);
		if(src_interval->upperBound > 1.0)
			src_interval->upperBound = 1.0;

		updateN_i(n_i, cc.symbols);
                //std::cout << n_i[0]<< ' '  << n_i[1] << ' ' << n_i[2] << n_i[3] << std::endl;
        
                code_symbols_new.splice(code_symbols_new.end(),cc.symbols);

                updateCodeCandidates(ccList, n_i);
		success = 0;
		for(std::list<struct codeCandidate>::iterator it = ccList->list.begin(); it != ccList->list.end(); ++it){
			cc = *it;
			if(src_interval->lowerBound >= cc.lowerBound && src_interval->upperBound <= cc.upperBound){
				success = 1;
				break;
			}
		}
	}
	free(p_i);
	return code_symbols_new;
}

std::list<int> encodeConstantCompositionArithmeticMatcher(std::list<int> src_symbols,int n, std::vector<int> n_i_vect){
	int k = (int)(n_i_vect.size());
	int *n_i;
	n_i = (int *) malloc(sizeof(int)*k);
	int i, m;
	double psrc[2] = {0.5,0.5};
	double *p_i;
	p_i = (double *) malloc(sizeof(double)*k);
	double sum_p_i = 0.0;

	std::list<int> code_symbols;
	std::list<int> fin_symbols;
	std::vector<double> dummyProb;

	struct sourceInterval srcInterval;
	struct codeCandidateList ccList;


	srcInterval.lowerBound = 0.0;
	srcInterval.upperBound = 1.0;

       

	for(i=0;i<k-1;i++)
	{
		n_i[i] =n_i_vect[i];
	}
	n_i[k-1]= n_i_vect[k-1];

	for(i=0;i<k;i++){
		p_i[i] = (double)(n_i[i])/(double)(n);
		struct codeCandidate cc_push;
		cc_push.lowerBound = sum_p_i;
		sum_p_i += p_i[i];
		if(i == k-1){
			cc_push.upperBound = 1.0; /* sum_p_i != 1 migh be true for numerical issues*/
		}
		else{cc_push.upperBound = sum_p_i;} // use case
		cc_push.upperBound = sum_p_i;
		cc_push.probability = p_i[i];
		cc_push.symbols.push_back(i+1);
		ccList.list.push_back(cc_push);
		ccList.k = k;
	}


	m = (int)(nchooseks_log2(n,n_i,k));


		for (std::list<int>::iterator it = src_symbols.begin(); it != src_symbols.end(); ++it)
		{
			int src_symbol = *it;
			/* UPDATE SOURCE INTERVAL*/
			updateSrcInterval(&srcInterval,psrc,src_symbol);
                        /* CheckForOutPutAndRescale */
			std::list<int> new_sym;
			new_sym = checkForOutputAndRescale(&srcInterval,&ccList,n_i);
                        

  			if (!new_sym.empty())
  			{
                                code_symbols.splice(code_symbols.end(),new_sym);
			}
		}

	/* FinalizeCodeSymbolse */
	fin_symbols = finalizeCodeSymbols(srcInterval,ccList,n_i);

	code_symbols.splice(code_symbols.end(),fin_symbols);


	free(p_i);
	free(n_i);

	return code_symbols;
}




void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	/*(std::list<int> src_symbols,
	int n,
	std::vector<double> code_probability)*/
	/*declare variables*/
	    mxArray *src_symbols_in_m, *n_in_m, *n_i_in_m, *code_symbols_out_m;
	    const mwSize *dims_n_i, *dims_src_sym;
	    int *src_symbols, *code_symbols, *n_i;
	    int dim_n_i_x, dim_n_i_y, dim_src_sym_x, dim_src_sym_y;
	    int n,i,j;
	    std::list<int> src_symbols_list;
	    std::list<int> code_symbols_list;
	    std::vector<int> n_i_vect;

	  /*associate inputs*/
	      src_symbols_in_m = mxDuplicateArray(prhs[0]);
	      n_i_in_m         = mxDuplicateArray(prhs[1]);

	/*figure out dimensions*/
	    dims_src_sym  = mxGetDimensions(prhs[0]);
		dim_src_sym_y = (int)dims_src_sym[0];
		dim_src_sym_x = (int)dims_src_sym[1];
		dims_n_i      = mxGetDimensions(prhs[1]);
		dim_n_i_y     = (int)dims_n_i[0];
        dim_n_i_x     = (int)dims_n_i[1];

  /*associate input pointers*/
      src_symbols = (int* ) mxGetData(src_symbols_in_m);
      n_i         = (int* ) mxGetData(n_i_in_m);
      
    n = 0;
    for (i = 0; i < dim_n_i_y * dim_n_i_x; i++){
		n_i_vect.push_back(n_i[i]);
        n += n_i[i];
    }

	/*associate outputs*/
	    code_symbols_out_m = plhs[0] = mxCreateNumericMatrix(1, n, mxINT32_CLASS, mxREAL);

	/*associate pointers*/
	    code_symbols = (int* ) mxGetData(code_symbols_out_m);

	for (i = 0; i < dim_src_sym_y * dim_src_sym_x; i++)
	    src_symbols_list.push_back(src_symbols[i]);

    code_symbols_list = encodeConstantCompositionArithmeticMatcher(src_symbols_list,n, n_i_vect);

	i = 0;
    for (std::list<int>::iterator it = code_symbols_list.begin(); it != code_symbols_list.end() ; ++it){
		code_symbols[i] = *it;
		i++;
	}

    return;
}
