throw Enum.sum Enum.map String.split(File.read!("i"),"
"),fn<<o,_,r>>->r-87+3*rem(r-o+8,3)end