# $Header$

     FC = f77
F77OPTS = -r8

knudsen2: knudsen2.o
	$(FC) -o knudsen2 knudsen2.o

.f.o:
	$(FC) $(F77OPTS) -c $<

clean:
	-rm knudsen2 *.o
