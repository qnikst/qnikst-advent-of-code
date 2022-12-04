const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("foo.txt", .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var total:usize=0;
    var total2:usize=0;
    while(try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
       var iter = std.mem.split(u8, line, ",");
       const first_line = iter.next() orelse "";
       const second_line = iter.next() orelse "";

       var first_iter = std.mem.split(u8, first_line, "-");
       const first_from = first_iter.next() orelse "";
       const first_to = first_iter.next() orelse "";

       const a1: usize = try std.fmt.parseInt(usize, first_from, 10);
       const b1: usize = try std.fmt.parseInt(usize, first_to, 10);

       var second_iter = std.mem.split(u8, second_line, "-");
       const second_from = second_iter.next() orelse "";
       const second_to = second_iter.next() orelse "";
      
       const a2: usize = try std.fmt.parseInt(usize, second_from, 10);
       const b2: usize = try std.fmt.parseInt(usize, second_to, 10);

       if ((a1 < a2 and b2 <= b1) or (a1>=a2 and b2 >= b1)) {
           total += 1;   
       }
       if (a2 <= b1 and a1<=b2) {
           total2 += 1;   
       }

    }

    try std.io.getStdOut().writer().print("Result: {}\nPt2: {}\n", .{total, total2});
}

