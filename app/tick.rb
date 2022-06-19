
def tick args
  #args.state.game ||= :running
  #args.state.gt ||= Snake.new(args)
  #args.state.gt.tick(args)
  puts "[0,1,0,0] #{SimulateTicks([0, 1, 0, 0], 0)}"
  puts SimulateTicks([0, 1, 0, 0], 1)
end
