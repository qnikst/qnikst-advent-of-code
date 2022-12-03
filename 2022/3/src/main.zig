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
    var sets : [3]std.DynamicBitSet = undefined;
    sets[0] = try std.DynamicBitSet.initEmpty(allocator, 52);
    sets[1] = try std.DynamicBitSet.initEmpty(allocator, 52);
    sets[2] = try std.DynamicBitSet.initEmpty(allocator, 52);
    defer sets[0].deinit();
    defer sets[1].deinit();
    defer sets[2].deinit();
    var index:usize=0;
    while(try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
      const i = index % 3;
      for (line) |c| {
         sets[i].set(score(c)-1);
      }
      if (i==2) {
        sets[0].setIntersection(sets[1]);
        sets[0].setIntersection(sets[2]);
        total_score += (sets[0].findFirstSet() orelse 0)+1;
        var j:usize=0;
        while (j<52) : (j+=1) {
           sets[0].unset(j);
           sets[1].unset(j);
           sets[2].unset(j);
        }
     }
     index+=1;
    }
    try std.io.getStdOut().writer().print("Task1: {}", .{total_score});
}

