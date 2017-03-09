helloworld: helloworld.o
	$(CC) $(LDFLAGS) -g helloworld.o -o helloworld
helloworld.o: helloworld.c
	$(CC) $(CFLAGS) -g -c helloworld.c

clean:
	rm *.o helloworld
