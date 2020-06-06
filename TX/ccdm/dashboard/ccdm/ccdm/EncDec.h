#ifndef ENCDEC_H
#define ENCDEC_H

#include <iostream>
#include <vector>
#include <math.h>
#include <stdlib.h>
#include <list>

std::list<int> encodeConstantCompositionArithmeticMatcher(std::list<int> src_symbols,int n, std::vector<int> n_i_vect);
int* decodeConstantCompositionArithmeticMatcher(std::list<int> code_symbols, std::vector<int> n_i_vect, int m);
 
#endif 