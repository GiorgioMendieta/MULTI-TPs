#include "stdio.h"

__attribute__((constructor)) void main()
{
	char c;
	char s[] = "\n Hello World! \n";

	while (1)
	{
		tty_puts(s);  // This function displays a string on a terminal.
		tty_getc(&c); // This blocking function fetches a single ascii character from a terminal
	}

} // end main
