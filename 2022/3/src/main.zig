const std = @import("std");

fn score(c: u8) usize {
   if (c < 'a') {
      return (c - 'A' + 27);
   }
   return (c - 'a' + 1);
}

pub fn main() !void {

    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    var allocator: std.mem.Allocator = gp.allocator();

    var file = try std.fs.cwd().openFile("foo.txt", .{});
    defer file.close();
    
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream  = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var total_score:usize = 0;
    while(try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
      var c1 = try std.DynamicBitSet.initEmpty(allocator, 52);
      defer c1.deinit();
      var c2 = try std.DynamicBitSet.initEmpty(allocator, 52);
      defer c2.deinit();
      const n = std.mem.len(line);
      for (line) |c, index| {
         // std.debug.print("{} -> {}\n", .{c, score(c)});
         if (index < n) {
            c1.set(score(c)-1);
         } else {
            c2.set(score(c)-1);
         }
         c1.setIntersection(c2);
         total_score += (c1.findFirstSet() orelse 0)+1;
      }
    }
    try std.io.getStdOut().writer().print("Task1: {}", .{total_score});
}

