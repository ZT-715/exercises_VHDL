
package sn74ls27_delays is

constant TPLH, TPHL: time := 15 ns;

end package;



use std.textio.all;

package threewaynor_test is
    procedure test_3_way_nor(
        signal a, b, c: out bit;
        signal y: in bit;
        constant TPLH, TPHL: time;
        constant file_path: string
    );
end package;


package body threewaynor_test is

    procedure test_3_way_nor(
        signal a, b, c: out bit;
        signal y: in bit;
        constant TPLH, TPHL: time;
        constant file_path: string
    ) is
        file fout: text open write_mode is file_path;
        variable lout: line;
        variable last_change: time := 0 fs;
    begin
        report "Start 3 way nor gate test."
        severity note;

        write(lout, string'("'x', 'w', 'z' | 'y'"));
        writeline(fout, lout);

        for x in bit loop
            for w in bit loop
                for z in bit loop
                    a <= x;
                    b <= w;
                    c <= z;
                    
                    if (not(x or (w or z))) /= y then
                        last_change := now;
                    end if;
                    
                    write(lout, bit'image(x) & string'(", ") &
                                bit'image(w) & string'(", ") &
                                bit'image(z));

                    wait until y'event for TPLH + TPHL;

                    write(lout, string'(" | ") &
                                bit'image(y) & 
                                string'(" -- Time since change: ") &
                                time'image(now - last_change));
                    writeline(fout, lout);

                    if (y'last_event = now) then
                        if y = '1' then
                            assert now - last_change = TPLH
                                report "TPLH not followed."
                                severity failure;
                        else
                            assert now - last_change = TPHL
                                report "TPHL not followed."
                                severity failure;
                        end if;
                    end if;

                    assert y = not(x or (w or z))
                        report time'image(now) & " - Incorrect logic operation. y = " &
                        bit'image(y)
                        severity failure;

                    wait for 10 ns;
                end loop;
            end loop;
        end loop;

        report "End 3 way nor gate functional tests."
        severity note;

        report "Start reject test."
        severity note;

        for x in bit loop
            for w in bit loop
                for z in bit loop
                    a <= x;
                    b <= w;
                    c <= z;
                    
                    if (not(x or (w or z))) /= y then
                    last_change := now;
                    end if;

                    wait until y'event for TPHL/2;

                    if (y'last_event = now) then
                        if y = '1' then
                            assert now - last_change = TPLH
                                report "TPLH not followed."
                                severity failure;
                        else
                            assert now - last_change = TPHL
                                report "TPHL not followed."
                                severity failure;
                        end if;

                        assert y = not(x or (w or z))
                            report time'image(now) & " - Incorrect logic operation. y = " &
                            bit'image(y)
                            severity failure;
                    end if;

                    wait for 0 fs;
                end loop;
            end loop;
        end loop;

        report "End reject test."
        severity note;
  
    wait;
    end procedure test_3_way_nor;

end package body;