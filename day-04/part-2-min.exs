import String
throw Enum.count split(File.read!("i"),"
"),fn l->[x,y]=Enum.map split(l,","),fn r->[s,e]=Enum.map split(r,"-"),&to_integer/1;s..e end;!Range.disjoint?x, y end