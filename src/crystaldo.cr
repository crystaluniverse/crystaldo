require "clim"

module CrystalTool
  class Cli < Clim
    main do
      desc "Crystal Tool."
      usage "ct [sub_command] [arguments]"
      help short: "-h"
      run do |opts, args|
        puts opts.help_string # => help string.
      end

      sub "git" do
        desc "work with git"
        usage "ct git [cmd] [arguments]"
        run do |opts, args|
          puts opts.help_string
        end        

        sub "pull" do
          help short: "-h"
          argument "giturl", type: String, required: true,
          desc: "
            url e.g. https://github.com/at-grandpa/clim
            url e.g. git@github.com:at-grandpa/clim.git
            "

          argument "dest", type: String,
            desc: "
              destination if not specified will be
              ~code/github/at-grandpa/clim
              "

          option "-v", "--verbose", type: Bool, desc: "Verbose."  
          option "-name", "--name", type: Bool, desc: "Will look for destination in ~/code which has this name, if found will use it"  
          option "-r", "--reset", type: Bool, desc: "Will reset the local git, means overwrite whatever changes done."  
          desc "get git repository, if local changes will ask to commit if in interactive mode (default)"
          usage "ct git get [options] [url]"
          run do |opts, args|
            # pp opts
            # pp args
            puts "git clone #{args.giturl} #{opts.verbose}"
          end
        end

      end

    end
  end
end

CrystalTool::Cli.start(ARGV)