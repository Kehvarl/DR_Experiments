
def tick args
  args.state.game ||= :running
  args.state.gt ||= Cycle.new(args)
  args.state.gt.tick(args)
end
