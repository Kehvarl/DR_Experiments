
def tick args
  args.state.gt ||= Cycle.new(args)
  args.state.gt.tick(args)
end
