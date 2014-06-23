% ========================================================================
% Sparse Variation Dictionary Learning for Face Recognition with A Single Sample Per Person, Version 1.0
% Copyright(c) 2013 Meng Yang, Luc Van Gool, and Lei Zhang
% All Rights Reserved.
%
% Please refer to the following our paper:
%
% Meng Yang, Luc Van Gool, and Lei Zhang, 
% "Sparse Variation Dictionary Learning for Face Recognition with A Single Sample Per Person," In Proc. ICCV 2013.
% 
% Contact: yangmengpolyu@gmail.com
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
%
% These are two implementations of the algorithm for Face Recognition without and with 
% occlusion on CMU-MPIE.
% 
% demo_mpie_svdl_s4-----An experiment to recognize the identity of face images from session 4
%
% demo_mpie_svdl_svdl_block------An experiment to recognize the identity of face images with block occlusion
%
% folder 'src': the source coding of sparse variation dictionary learning
%
% Notes: 
% we provide two .mat files of MPIE only for testing our demos; 
% In testing phase, "SolveDALM.m" is used to solve the sparse coding problem. 
% We thank Allen Yang for providing the toolbox of "L1Solvers" on the website of "http://www.eecs.berkeley.edu/~yang/software/l1benchmark/index.html". 
% ----------------------------------------------------------------------
