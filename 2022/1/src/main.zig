const std = @import("std");

fn cmp(_: void, a:i32, b:i32) bool {
   return (a > b);
}

pub fn main() !void {

    var gp = std.heap.GeneralPurposeAllocator(.{ }){};
    defer _ = gp.deinit();
    var allocator: std.mem.Allocator = gp.allocator();

    var file = try std.fs.cwd().openFile("foo.txt", .{});
    defer file.close();
    
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var current: i32 = 0;
    
    const List = std.ArrayList(i32);
    var list = List.init(allocator);
    defer list.deinit();

    while( try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
      if (std.mem.eql(u8,line,"")) {
         try list.append(current);
         current = 0;
      } else {
         current += try std.fmt.parseInt(i32, line, 10);
      }
    }
    var x = list.toOwnedSlice();
    std.sort.sort(i32, x, {}, cmp);
    try std.io.getStdOut().writer().print("{}\n", .{x[0]+x[1]+x[2]});
    allocator.free(x);
}

