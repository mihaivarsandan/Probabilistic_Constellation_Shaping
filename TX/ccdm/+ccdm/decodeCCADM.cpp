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

/* updates 1-based symbols. functionality works. */
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
    /* update remaining symbols */
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
    /* check if output is possible */
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
        code_symbols_new.splice(code_symbols_new.end(),cc.symbols);


        /* empty list */
        updateCodeCandidates(ccList,n_i);
        /* check if output is possible */
        success = 0;
        for(std::list<struct codeCandidate>::iterator it = ccList->list.begin(); it != ccList->list.end(); ++it){
            cc = *it;
            if(src_interval->lowerBound >= cc.lowerBound && src_interval->upperBound <= cc.upperBound){
                success = 1;
                /* right cc chosen */
                break;
            }
        }
    }
    free(p_i);
    return code_symbols_new;
}


/*std::list<int> decodeConstantCompositionArithmeticMatcher(std::list<int> code_symbols, std::vector<int> n_i_vect, int m){*/
int* decodeConstantCompositionArithmeticMatcher(std::list<int> code_symbols, std::vector<int> n_i_vect, int m){
    int n = (int) code_symbols.size();
    int k = n_i_vect.size();
    int *n_i = (int *) malloc(k*sizeof(int));
    int *n_i_future = (int *) malloc(k*sizeof(int));
    int n_future = n;
    double *p_i = (double*) malloc(k*sizeof(double));
    int sum_n_i = 0;
    double sum_p_i = 0.0;
    double new_border;
    struct sourceInterval srcInterval;
    struct sourceInterval codeInterval;

    struct codeCandidateList ccList;
    ccList.k = k;

   
    /* Initialize n_i, candidates*/
    for(int i=0;i<k-1;i++)
    {
            n_i[i] =n_i_vect[i];
    }
    n_i[k-1]= n_i_vect[k-1];
    updateCodeCandidates(&ccList,n_i);

    int *src_symbols = (int*)malloc(m*sizeof(int));
    int src_symbol_index = 0;

    /* Initialize srcInterval, codeInterval*/
    srcInterval.lowerBound = 0;
    srcInterval.upperBound = 1;

    std::list<int> code_symbols_unprocessed;
    std::list<int>::iterator code_symbol_iterator = code_symbols.begin();
    std::list<int>::iterator code_interval_symbol_iterator;
    while (code_symbol_iterator != code_symbols.end())
    {
        code_symbols_unprocessed.push_back(*code_symbol_iterator);
        codeInterval = findCodeIntervalFromCandidates(ccList,&code_symbols_unprocessed);
        if (!code_symbols_unprocessed.empty())
        {
            continue;
        }

        code_interval_symbol_iterator = code_symbol_iterator;
        n_future = n;
        for(int i = 0; i<k; i++)
        {
            n_i_future[i] = n_i[i];
        }
        n_i_future[*code_symbol_iterator-1] -= 1;
        n_future -= 1;
        code_interval_symbol_iterator++;

        bool scaling_performed = 0;
        while(!scaling_performed)
        {
            new_border = srcInterval.lowerBound + (srcInterval.upperBound - srcInterval.lowerBound) * 0.5; /* 0.5 = srcProbability*/
            while((codeInterval.lowerBound >= new_border)|| (codeInterval.upperBound < new_border))
            {
                if(codeInterval.lowerBound >= new_border)
                {
                    src_symbols[src_symbol_index] = 1; /* writing out a symbol */
                    src_symbol_index++;
                    srcInterval.lowerBound = new_border;
                }
                else if (codeInterval.upperBound< new_border)
                {
                    src_symbols[src_symbol_index] = 0; /* writing out a symbol */
                    src_symbol_index++;
                    srcInterval.upperBound = new_border;
                }

                if (src_symbol_index >= m)
                {
                    free(p_i);
                    free(n_i);
                    free(n_i_future);
                    return src_symbols;
                }

                new_border = srcInterval.lowerBound + (srcInterval.upperBound - srcInterval.lowerBound) * 0.5; /* 0.5 = srcProbability*/

                struct sourceInterval checksrcInterval = srcInterval;
                std::list<int> checkcode = checkForOutputAndRescale(&checksrcInterval, &ccList, n_i);
                
                if( checksrcInterval.lowerBound != srcInterval.lowerBound || checksrcInterval.upperBound != srcInterval.upperBound)
                {
                    std::advance(code_symbol_iterator,checkcode.size());
                    srcInterval = checksrcInterval;
                    scaling_performed = 1;
                    break;
                }
            }

            if (code_interval_symbol_iterator == code_symbols.end())
            {
                codeInterval.upperBound = codeInterval.lowerBound + 0.01*(codeInterval.upperBound - codeInterval.lowerBound); /* magic...*/
            }
            else
            {
                int code_interval_symbol = *code_interval_symbol_iterator;
                double lbound, ubound;
                struct sourceInterval buffer;
                std::list<int> code_interval_symbol_shortlist;
                code_interval_symbol_shortlist.push_back(code_interval_symbol);


                sum_p_i = 0;
                n = 0;
                for(int i=0;i<k;i++)
                    n += n_i_future[i];
                sum_n_i = 0;
                for(int i=0;i<code_interval_symbol-1;i++)
                    sum_n_i += n_i_future[i];
                lbound = (double)(sum_n_i)/(double)(n);
                sum_n_i += n_i_future[code_interval_symbol-1];
                ubound = (double)(sum_n_i)/(double)(n);

                buffer.lowerBound = codeInterval.lowerBound + (codeInterval.upperBound - codeInterval.lowerBound) * lbound;
                buffer.upperBound = codeInterval.lowerBound + (codeInterval.upperBound - codeInterval.lowerBound) * ubound;
                codeInterval = buffer;

                n_i_future[*code_interval_symbol_iterator-1] -= 1;
                n_future --;
                code_interval_symbol_iterator++;
            }
        }
    }
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    /*declare variables*/
    mxArray *code_symbols_in_m, *n_i_in_m, *m_in_m, *source_symbols_out_m;
    const mwSize *dims_n_i, *dims_code_sym;
    int *n_i,*code_symbols;
    int *source_symbols;
    int *source_symbols2;
    int dim_n_i_x, dim_n_i_y;
    int dim_code_sym_x, dim_code_sym_y;
    int i,j;
    std::list<int> code_symbols_list;
    std::vector<int> n_i_vect;
    int *m;

    /*associate inputs*/
    code_symbols_in_m = mxDuplicateArray(prhs[0]);
    n_i_in_m          = mxDuplicateArray(prhs[1]);
    m_in_m            = mxDuplicateArray(prhs[2]);


    /*figure out dimensions*/
    dims_code_sym = mxGetDimensions(prhs[0]);
    dim_code_sym_y = (int)dims_code_sym[0];
    dim_code_sym_x = (int)dims_code_sym[1];

    dims_n_i = mxGetDimensions(prhs[1]);
    dim_n_i_y = (int)dims_n_i[0];
    dim_n_i_x = (int)dims_n_i[1];

    /*associate input pointers*/
    code_symbols  = (int* ) mxGetData(code_symbols_in_m);
    n_i           = (int* ) mxGetData(n_i_in_m);
    m             = (int* ) mxGetData(m_in_m);


    /*associate output*/
    source_symbols_out_m = plhs[0] = mxCreateNumericMatrix(1, *m, mxINT32_CLASS, mxREAL);

    /*associate pointers*/
    source_symbols = (int* ) mxGetData(source_symbols_out_m);

    /*do something*/

    for (i = 0; i < dim_n_i_y * dim_n_i_x; i++){
        n_i_vect.push_back(n_i[i]);
    }
    for (i = 0; i < dim_code_sym_y * dim_code_sym_x; i++){
        code_symbols_list.push_back(code_symbols[i]);
    }

    source_symbols2 = decodeConstantCompositionArithmeticMatcher( code_symbols_list, n_i_vect, *m);
    for (i = 0; i  <((int)(*m)); i++)
    {
        source_symbols[i] = source_symbols2[i];
    }
    free(source_symbols2);
    return;
}
