#include <iostream>
#include <math.h>
#include "EncDec.h"
#include <vector>
#include <stdlib.h>
#include <list>

bool checkOutput(std::list<int> src_symbols, int *src_symbols_hat)
{
	int j = 0;
	bool success = 1;
	for (std::list<int>::iterator it = src_symbols.begin(); it != src_symbols.end(); it++)
	{
		if (*it != src_symbols_hat[j])
			success = 0;
		j++;
	}
	if (!success)
	{
		std::cout << "TEST SEQUENCE GENERATED!" << std::endl;
		j = 0;
		for (std::list<int>::iterator it = src_symbols.begin(); it != src_symbols.end(); it++)
		{
			std::cout << *it << ' ' <<  src_symbols_hat[j] << std::endl;
			j++;
		}
		std::cin >> j;
		return success;
	}
	return success;
}

void fillList(std::list<int> *src_symbols, int fillint, int length)
{
	src_symbols->clear();
	for(int i= 0; i<length; i++)
	{
		src_symbols->push_back((fillint >>i) % 2);
	}
}

int main(void)
{
	unsigned int i = -1;

	std::list<int> encodedList;
	std::list<int> src_symbols;
	/*src_symbols.push_back(0);
	src_symbols.push_back(1);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);
	src_symbols.push_back(0);*/
	int	 n = 10;
	std::vector<int> n_i_vect;
	n_i_vect.push_back(2);
	n_i_vect.push_back(2);
	n_i_vect.push_back(2);
	n_i_vect.push_back(2);
	n_i_vect.push_back(2);
	int *src_symbols_hat;

	// Brut force calculation
	for (int seq = 0; seq < (1<<16); seq++)
	{
		fillList(&src_symbols,seq,16);
		encodedList = encodeConstantCompositionArithmeticMatcher(src_symbols,n, n_i_vect);
		/*for (std::list<int>::iterator it = encodedList.begin(); it != encodedList.end(); it++)
			std::cout << *it << ' ';*/
		src_symbols_hat = decodeConstantCompositionArithmeticMatcher(encodedList, n_i_vect, 16);
		if (!checkOutput(src_symbols, src_symbols_hat))
		{			
			std::cin >> i;
		}
	}

	/*encodedList = encodeConstantCompositionArithmeticMatcher(src_symbols,n, n_i_vect);
	src_symbols_hat = decodeConstantCompositionArithmeticMatcher(encodedList, n_i_vect, 11);
	int j = 0;
	for (std::list<int>::iterator it = src_symbols.begin(); it != src_symbols.end(); it++)
	{
		std::cout << *it << ' ' <<  src_symbols_hat[j] << std::endl;
		j++;
	}*/


	//std::cout << "Size of int:" << sizeof(unsigned int)<< std::endl;
	//std::cout << "Size of long:" << sizeof(unsigned long)<< std::endl;
	//std::cout << "Size of long long:" << sizeof(unsigned long long)<< std::endl;
	for (std::list<int>::iterator it = encodedList.begin(); it != encodedList.end(); it++)
		std::cout << *it << ' ';
	
	//std::cout << "Soll sein: " << (i>>30) << std::endl;
	std::cin >> i;
	return 0;
}