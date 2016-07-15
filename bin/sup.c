#include <unistd.h>

main(int argc, char **argv)
{
    if (argc == 1)
        exit (0);

    /* set Real user Id with effective Value */
    setuid(geteuid());
    setgid(getegid());

    if ( execvp ( argv[1], &argv[1]) == -1 )
        perror("sup");
}
