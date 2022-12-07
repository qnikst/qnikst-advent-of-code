const std = @import("std");

pub fn groups(std.Iterator(a), a -> bool) std.Iterator(std.Iterator(a), a-> bool){
}

pub fn iterateBlocks(reader: std.io.Reader) !void {
    var x = fn() -> std.Iterator([] const u8) {
       var buf = try reader.readLine();
       while (not std.mem.eql(buf, "")) {
         yield(buf);
         buf = try reader.readLine() 
       }
    }
    while  
}

pub fn main() !void {

    var gp = std.heap.GeneralPurposeAllocator(.{ }){};
    defer _ = gp.deinit();
    var allocator: std.mem.Allocator = gp.allocator();

    var file = try std.fs.cwd().openFile("foo.txt", .{});
    defer file.close();
    
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024] u8 = undefined;

    var current: usize = 0;
    
    var list = std.ArrayList(usize).init(allocator);
    defer list.deinit();

    while( try iter.next() ) |line| {
      if (std.mem.eql(u8,line,"")) {
         try list.append(current);
         current = 0;
      } else {
         current += try std.fmt.parseInt(usize, line, 10);
      }
    }
     
    { 
      var x = list.toOwnedSlice();
      defer allocator.free(x);
      std.sort.sort(usize, x, {}, 
         struct{
             fn function(_: void, a:usize, b:usize) bool {
                 return (a > b);
             }
         }.function,
      );
      try std.io.getStdOut().writer().print("{}\n", .{x[0]+x[1]+x[2]});
    }
}

