import String
import MapSet
throw Enum.count Enum.map(split(File.read!("i"),"
"),fn l->Enum.map(split(l,","),fn r->[s,e]=Enum.map(split(r,"-"),&to_integer/1);new(s..e)end)end),fn[x,y]->subset?(x,y)||subset?(y,x)end