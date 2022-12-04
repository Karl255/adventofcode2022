import String
import MapSet
throw Enum.count split(File.read!("i"),"
"),fn l->[x,y]=Enum.map split(l,","),fn r->[s,e]=Enum.map split(r,"-"),&to_integer/1;new s..e end;subset?(x,y)||subset?y,x end