
def tick args
  args.state.game ||= :running
  args.state.gt ||= Snake.new(args)
  args.state.gt.tick(args)
end
