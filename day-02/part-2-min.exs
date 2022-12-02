throw Enum.sum Enum.map String.split(File.read!("i"),"
"),fn<<o,_,r>>->rem(r+47-2*o,3)+1+3*(r-88)end