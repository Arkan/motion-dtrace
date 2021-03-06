#!/usr/sbin/dtrace -s
/* https://raw.github.com/MacRuby/MacRuby/master/sample-macruby/DTrace/methods_count.d */

#pragma D option quiet

BEGIN
{
    printf("Target pid: %d\n\n", $target);
}

macruby$target:::method-entry
/copyinstr(arg0) != "TopLevel"/
{
/*    printf("%30s:%-5d %s#%s\n", copyinstr(arg2), arg3, 
	    copyinstr(arg0), copyinstr(arg1));
*/
    @methods_count[copyinstr(arg0), copyinstr(arg1)] = count();
}

END
{
    printf("\n");
    printf("%30s       %-30s  %s\n", "CLASS", "METHOD", "COUNT");
    printf("--------------------------------------------------------------------------------\n");
    printa("%30s       %-30s  %@d\n", @methods_count);
}
