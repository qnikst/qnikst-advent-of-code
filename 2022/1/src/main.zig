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

    const buffer_size = 2000000;
    const file_buffer = try file.readToEndAlloc(allocator, buffer_size);
    defer allocator.free(file_buffer);

    var current: i32 = 0;
    
    const List = std.ArrayList(i32);
    var list = List.init(allocator);
    defer list.deinit();

    var iter= std.mem.split(u8, file_buffer, "\n");
    while (iter.next()) |line| : {
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

