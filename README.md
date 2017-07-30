# property_to_Bfac

Simple awk script to transfer properties indexed by amino acid type to the Bfactor column of the pdb file. 
Use to generate coordinates that can be colored by B-factor in PyMol to display the distribution of some property (e.g. hydrophobicity, or whatever). 

Handles 1 or 3-letter AA code, does simple error checking. 

Input 1 - white space separated amino acid / property pairs

Input 2 - pdb file to modify 

Usage -      
<i> ./property_to_Bfac.awk values_table.txt input.pdb > output.pdb </i>

