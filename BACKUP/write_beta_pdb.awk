#!/usr/bin/awk -f
# -*- coding: UTF8 -*-

# Author: Guillaume Bouvier -- guillaume.bouvier@pasteur.fr
# https://research.pasteur.fr/en/member/guillaume-bouvier/
# 2015-11-26 15:19:49 (UTC+0100)

# •Add data to b-factor field in a Protein Data Bank file (pdb)
#  The values are values per residue of amino acid
# •Usage:
#    ./write_beta_pdb.awk beta_values.txt file.pdb > out.pdb

BEGIN{
    # Reading Fixed-Width Data (see: https://goo.gl/SmjwUt)
    FIELDWIDTHS = "6 5 1 4 1 3 1 1 4 1 3 8 8 8 6 6 6 4"
    # $2: Atom serial number
    # $5: altLoc; alternate location indicator.
    # $6: Resname
    # $8: ChainID
    # $9: Resid
    # $12: x
    # $13: y
    # $14: z
    # $16: b-factor
}

{
    if (NR == FNR){
        i++
        beta[i]=$1 # Read beta values and store them in an array
    }
    else{
        if ($1=="ATOM  ") {
            if($9 != p){ # Read residue id
                j++
                p=$9
            }
            printf("%-6s%5s%1s%4s%1s%3s%1s%1s%4s%1s%3s%8s%8s%8s%6s%6s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,beta[j],beta[j])
        }
    }
}
