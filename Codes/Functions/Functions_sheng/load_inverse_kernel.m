function [ inverse_kernel ] = load_inverse_kernel( brainstorm_db, subject, InverseKernelType)
%LOAD_INVERSE_KERNEL Summary of this function goes here
%   Detailed explanation goes here
directory = [brainstorm_db '/' subject '/@default_study/'];
files = dir([directory '*' InverseKernelType '*.mat']);    
load([directory files(1).name]);
inverse_kernel = ImagingKernel;
end

