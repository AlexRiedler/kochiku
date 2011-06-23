class BuildPartJob < JobBase
  attr_reader :build_part, :build

  def initialize(build_part_id)
    @build_part = BuildPart.find(build_part_id)
    @build = build_part.build
  end

  def perform
    GitRepo.inside_copy('web-cache', build.sha, true) do
      # TODO:
      # collect stdout, stderr, and any logs
      result = tests_green? ? :passed : :failed
      build_part.build_part_results.create(:result => result)
    end
  end

  def tests_green?
    ENV["TEST_RUNNER"] = build_part.kind
    ENV["RUN_LIST"] = build_part.paths.join(",")
    system("env -i HOME=$HOME bash --noprofile --norc -c 'ruby -v ; source ~/.rvm/scripts/rvm ; rvm use ree ; script/ci worker'")
  end

end
