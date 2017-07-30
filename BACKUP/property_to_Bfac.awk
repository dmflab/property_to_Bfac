#!/usr/bin/awk -f
# -*- coding: UTF8 -*-
#
# dmf 7.29.17 property_to_Bfac.awk
# 
# Based on write_beta_pdb.awk Author: Guillaume Bouvier -- guillaume.bouvier@pasteur.fr
# https://bougui505.github.io/2015/11/26/write_data_to_b-factor_column_of_a_pdb_file.html
# dmf 7.29.17 ok, FILEDWIDTHS does not appear to be implemented here... so, not really 
# based on this code, other than for its simplicity
# 
# input 1: file with amino acid names (three letter code) and property value
# input 2: pdb file
# •Usage:
#    ./property_to_Bfac.awk values_table.txt input.pdb > output.pdb
#
# DO:
# add an inital comment line that states how the file has been modified
#

BEGIN{ PropertyValue[""]=0; # associative table of property values
        # amino acid lookup table -
        aa3["A"]="ALA";
        aa3["R"]="ARG";
        aa3["D"]="ASP";
        aa3["N"]="ASN";
        aa3["C"]="CYS";
        aa3["E"]="GLU";
        aa3["Q"]="GLN";
        aa3["G"]="GLY";
        aa3["H"]="HIS";
        aa3["L"]="LEU";
        aa3["K"]="LYS";
        aa3["M"]="MET";
        aa3["F"]="PHE";
        aa3["P"]="PRO";
        aa3["S"]="SER";
        aa3["T"]="THR";
        aa3["W"]="TRP";
        aa3["Y"]="TYR";
        aa3["V"]="VAL";
        # create a header with the creation date
        "date '+%d/%b/%Y'" | getline date ;
        printf("REMARK\nREMARK File created: %s using property_to_Bfac.awk\n", date)
      }

{
    if (NR == FNR){ 	# i.e. process the first (table) file 
	# create associative array from input file amino acid / property value pairs

        # add header lines identifying the table file and what has been done
        if (NR == 1) {
            printf("REMARK Source properties file is: %s\n",FILENAME)
        }

        # force uppercase
        aa = toupper($1)
        # and convert single letter to three letter code
        if (length(aa) == 1) aa = aa3[aa]

        # check range of property value
        if ($2 < -99.00 || $2 > 999.00) {
            printf("\n Stop. Property value out of range (limit -99.00 to 999.00): %s %s\n\n", aa, $2)
            exit
        }

        # assign value indexed by amino acid name
        PropertyValue[aa] = $2;
    }
    else{ 		# i.e. process the second (pdb) file 

        # add a header line with the name of the coordinate file
        if (FNR == 1) {
            printf("REMARK Source coordinate file is: %s\n", FILENAME)
            printf("REMARK Property values are mapped to BFACTOR\n");
            printf("REMARK\n")
        }

        if ($1=="ATOM") {

            resname = substr($0, 18, 3);
            # simply assign the value to every atom in the residue for now
            # could imagine restricting this to sidechain atoms in the future (or something else)
            printf("%s%6.2f%s\n", substr($0,1,60), PropertyValue[resname], substr($0, 67, 12))

        } else {
            # just dump the line back out
            printf("%s\n",$0);
        }
    }
}
