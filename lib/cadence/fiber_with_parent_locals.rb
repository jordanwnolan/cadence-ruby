require 'fiber'
# This class wraps ruby's Fiber, but copies all the thread-local variables from the parent Thread
#
# In Ruby it is not uncommon to store information in Thread.current[] variables, which will not be
# accessible within a regular Fiber
#
module Cadence
  class FiberWithParentLocals < Fiber
    def self.new
      thread_locals = Thread.current.keys.map do |key|
        next if key == Cadence::ThreadLocalContext::WORKFLOW_CONTEXT_KEY

        [key, Thread.current[key]]
      end

      super do
        # thread_locals.each { |(key, value)| Thread.current[key] = value.clone }
        yield
      end
    end
  end
end