
def tick args
  args.state.gt ||= Ground_Generate.new(args)
  args.state.gt.tick(args)
end
