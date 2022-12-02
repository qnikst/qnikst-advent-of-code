const std = @import("std");

const RPC = enum { rock, paper, scissors, };

const Result = enum { loose, draw, win };

fn fromInput(input: u8) RPC {
   if (input=='A') {
     return RPC.rock;
   }
   if (input=='B') {
     return RPC.paper;
   }
   if (input=='C') {
     return RPC.scissors;
   }
   unreachable;
}

fn fromYourInput(input: u8) RPC {
   if (input=='X') {
     return RPC.rock;
   }
   if (input=='Y') {
     return RPC.paper;
   }
   if (input=='Z') {
     return RPC.scissors;
   }
   unreachable;
}

fn fromInputResult(input: u8) Result {
   if (input=='X') {
      return Result.loose;
   }
   if (input=='Y') {
      return Result.draw;
   }
   if (input=='Z') {
     return Result.win;
   }
   unreachable;
}

fn scoreRPC(rpc: RPC) i32 {
   return switch (rpc) {
      RPC.rock => 1,
      RPC.paper => 2,
      RPC.scissors => 3
   };
}

fn scoreResult(result: Result) i32 {
   return switch (result) {
     Result.loose => 0,
     Result.draw => 3,
     Result.win => 6
   };
}

fn  compare(opponent: RPC, you: RPC) Result {
   return switch (opponent) {
     RPC.rock => 
     switch (you) {
      RPC.rock => Result.draw,
      RPC.paper => Result.win,
      RPC.scissors => Result.loose,
     },
     RPC.paper => switch (you) {
      RPC.rock => Result.loose,
      RPC.paper => Result.draw,
      RPC.scissors => Result.win,
     },
     RPC.scissors => switch (you) {
      RPC.rock => Result.win,
      RPC.paper => Result.loose,
      RPC.scissors => Result.draw
     }
   };
}

fn strategy(oppenent: RPC, result: Result) RPC {
   return switch (oppenent) {
     RPC.rock =>
      switch (result) {
      Result.draw => RPC.rock,
      Result.win => RPC.paper,
      Result.loose => RPC.scissors,
      },
     RPC.paper => switch (result) {
      Result.loose => RPC.rock,
      Result.draw => RPC.paper,
      Result.win => RPC.scissors,
      },
     RPC.scissors => switch  (result) {
      Result.win => RPC.rock,
      Result.loose => RPC.paper,
      Result.draw => RPC.scissors
     }
   };
}

pub fn main() !void {
   var file = try std.fs.cwd().openFile("foo.txt", .{});
   defer file.close();
   var buf_reader = std.io.bufferedReader(file.reader());
   var in_stream = buf_reader.reader();
   var buf: [1024]u8 = undefined;
   var task1: i32 = 0;
   var task2: i32 = 0;
   while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
      const their = fromInput(line[0]);
      const your = fromYourInput(line[2]);
      const result = fromInputResult(line[2]);
      task1 += scoreRPC(your) + scoreResult(compare(their, your));
      task2 += scoreResult(result) + scoreRPC(strategy(their, result));
   }
   try std.io.getStdOut().writer().print("Task1: {}\nTask2: {}\n", .{task1, task2});
   
   
}

