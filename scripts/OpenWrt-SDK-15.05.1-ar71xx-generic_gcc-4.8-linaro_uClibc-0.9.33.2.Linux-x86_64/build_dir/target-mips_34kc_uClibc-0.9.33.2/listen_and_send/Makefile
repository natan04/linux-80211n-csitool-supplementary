listen_and_send: listen_and_send.o
	$(CC) $(LDFLAGS) -g listen_and_send.o -o listen_and_send
listen_and_send.o: listen_and_send.c
	$(CC) $(CFLAGS) -g -c listen_and_send.c

clean:
	rm *.o listen_and_send
