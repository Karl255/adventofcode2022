import String
throw Enum.count Enum.map(split(File.read!("i"),"
"),fn l->Enum.map(split(l,","),fn r->[s,e]=Enum.map(split(r,"-"),&to_integer/1);s..e end)end),fn[x,y]->!Range.disjoint?(x,y)end