# Canu_to_Unicycler_input
A proof of concept script to convert a Canu assembly graph and fasta assembly into the input format for the Unicycler "--existing_long_read_assembly" option. The script converts complex CIGAR strings into simple overlap counts. Currently it only handles the overlap cigar components M,I,D.

Run as follows:
./convert_canugraph_to_unicyclerinput.sh mydataset.contigs.gfa mydataset.contigs.fasta > mydataset.contigs.fixed.gfa

This has only been tested on Canu v.1.8 and Unicycler v.0.4.7.
