require "clim"
require "crystaltools"
require "./gittrigger"

module CrystalDo
  class Cli < Clim
    include CrystalTools

    main do
      desc "Crystal Tool."
      usage "ct [sub_command] [arguments]"
      help short: "-h"

      run do |opts, args|
        puts opts.help_string # => help string.
      end

      sub "stop" do
        desc "cleanup"
        help short: "-h"
        usage "ct stop"
        run do |opts, args|
          RedisFactory.core_stop()
        end
      end

      sub "code" do
        desc "open code editor (visual studio code)"
        help short: "-h"
        usage "ct code NAME"
        argument "name", type: String, required: false, desc: "name of the repo, if not mentioned is the last one", default: ""
        option "-e WORD", "--env=WORD", type: String, desc: "environment can be e.g. testing, production, is a prefix to github dir in code.", default: ""
        run do |opts, args|
          gitrepo_factory = GITRepoFactory.new
          r = gitrepo_factory.get(name: args.name , environment: opts.env)          
          Executor.exec "code '#{r.@path}'"
        end
      end


      # TODO: hamdy, how can we make this more modular, want to put in different files, e.g. per topic e.g. git
      sub "git" do
        desc "work with git"
        help short: "-h"
        usage "ct git [cmd] [arguments]"
        run do |opts, args|
          puts opts.help_string
        end


        sub "push" do

          help short: "-h"
          usage "ct git push [options] "
          desc "commit changes & push to git repository"

          option "-e WORD", "--env=WORD", type: String, desc: "environment can be e.g. testing, production, is a prefix to github dir in code.", default: ""
          option "-v", "--verbose", type: Bool, desc: "Verbose."
          option "-n WORDS", "--name=WORDS", type: String, desc: "Will look for destination in ~/code which has this name, if found will use it", default: ""
          option "-b WORDS", "--branch=WORDS", type: String, desc: "If we need to change the branch for push", default: ""
          argument "message", type: String, required: true, desc: "message for the commit when pushing"

          run do |opts, args|

            gitrepo_factory = GITRepoFactory.new
            names = gitrepo_factory.repo_names_get opts.name
            names.each do |name2|
              # CrystalTools.log "push/commit #{name2}", 1
              r = gitrepo_factory.get(name: name2, environment: opts.env)
              if opts.branch != ""
                raise "not implemented"
              end
              r.commit_pull_push(msg: args.message)
            end
          end

        end

        sub "pull" do
          help short: "-h"
          usage "ct git pull [options] "
          desc "pull git repository, if local changes will ask to commit if in interactive mode (default)"

          option "-d WORDS", "--dest=WORDS", type: String, default: "",
            desc: "
              destination if not specified will be
              ~code/github/$account/$repo/
              "

          option "-e WORD", "--env=WORD", type: String, desc: "environment can be e.g. testing, production, is a prefix to github dir in code.", default: ""
          option "-v", "--verbose", type: Bool, desc: "Verbose."
          option "-n WORD", "--name=WORD", type: String, desc: "Will look for destination in ~/code which has this name, if found will use it", default: ""
          option "-b WORD", "--branch=WORD", type: String, desc: "Branch of the repo, not needed to specify", default: ""
          option "-r WORD", "--reset=WORD", type: Bool, desc: "Will reset the local git, means overwrite whatever changes done.", default: false
          option "--depth=WORD", type: Int32, desc: "Depth of cloning. default all.", default: 0

          argument "url", type: String, required: false, default: "",
            desc: "
              pull git repository, if local changes will ask to commit if in interactive mode (default)
              url e.g. https://github.com/at-grandpa/clim
              url e.g. git@github.com:at-grandpa/clim.git
              "

          run do |opts, args|

            gitrepo_factory = GITRepoFactory.new
            names = gitrepo_factory.repo_names_get opts.name
            names.each do |name2| 
              puts "PULL: #{name2}"               
              r = gitrepo_factory.get(name: name2, path: opts.dest, url: args.url, branch: opts.branch)
              if opts.env != ""
                r.environment = opts.env
              end
              if opts.branch != ""
                r.branch = opts.branch
              end
              if opts.reset
                r.reset
              else
                r.pull
              end
              # gitrepo_factory.repo_remember r
            end
          end
        end
      end

      sub "tmux" do
        help short: "-h"
        desc "work with tmux"
        usage "ct tmux [cmd] [options]"
        run do |opts, args|
          puts opts.help_string
        end

        sub "list" do
          help short: "-h"
          usage "ct tmux list [options] "
          desc "find all sessions & windows"
          option "-s WORD", "--session=WORD", type: String, desc: "Name of session", default: "default"

          run do |opts, args|
            TMUXFactory.list(session = opts.session)
          end
        end

        sub "stop" do
          help short: "-h"
          usage "ct tmux stop[options] "
          desc "stop a window or the fill session, if window not specified will kill the session"
          option "-n WORDS", "--name=WORDS", type: String, desc: "Name of session", default: ""
          option "-w WORDS", "--window=WORDS", type: String, desc: "Name of window", default: ""

          run do |opts, args|
            if opts.window == "" && opts.name == ""
              TMUXFactory.stop()
              return
            end
            session = TMUXFactory.session_get(name: opts.name)
            if opts.window == ""
              session.stop
            else
              window = session.window_get(name: opts.window)
              window.stop
            end
            TMUXFactory.list
          end
        end

        sub "run" do
          help short: "-h"
          usage "ct tmux run cmd [options] "
          desc "run a command in a window in a tmux session"
          option "-n WORDS", "--name=WORDS", type: String, desc: "Name of session", default: "default"
          option "-w WORDS", "--window=WORDS", type: String, desc: "Name of window", default: "default"
          option "-r", "--reset", type: Bool, desc: "Kill the window first", default: true
          option "-c WORDS", "--check=WORDS", type: String, desc: "Check to do, look for string in output of window.", default: ""
          argument "cmd", type: String, required: true, desc: "command to execute in the window"

          run do |opts, args|
            session = TMUXFactory.session_get(name: opts.name)
            window = session.window_get(name: opts.window)
            window.execute cmd: args.cmd, check: opts.check, reset: opts.reset
          end
        end
      end

      sub "sshconn" do
        help short: "-h"
        desc "work with ssh tunnels"
        usage "ct sshconn [cmd] [options]"
        run do |opts, args|
          puts opts.help_string
        end

        sub "start" do
          help short: "-h"
          usage "ct sshconn start [options]"
          desc "establish ssh tunnels connections"
          argument "config", type: String, required: true, desc: "configuration file path"

          run do |opts, args|
            sshconn = SSHConnectionTool.new args.config
            sshconn.start
          end
        end
      end

      sub "neph" do
        help short: "-h"
        desc "work with neph"
        usage "ct neph [cmd] [options]"
        run do |opts, args|
          puts opts.help_string
        end

        sub "exec" do
          help short: "-h"
          usage "ct neph exec [options]"
          desc "execute jobs using neph"

          option "-l WORD", "--log-mode=WORD", type: String, desc: "Log modes [NORMAL/CI/QUIET/AUTO]", default: "AUTO"
          option "-e WORD", "--exec-mode=WORD", type: String, desc: "Execution modes [parallel/sequential]", default: "parallel"
          argument "config", type: String, required: true, desc: "configuration file path"

          run do |opts, args|
            neph = NephExecuter.new config_path: args.config, log_mode: opts.log_mode, exec_mode: opts.exec_mode
            neph.exec
          end
        end

        sub "clean" do
          help short: "-h"
          usage "ct neph clean"
          desc "cleaning caches"
          run do |opts, args|
            neph = NephExecuter.new
            neph.clean
          end
        end
      end

      sub "gittrigger" do
        help short: "-h"
        desc "work with git trigger"
        usage "ct gittrigger [cmd] [options]"
        run do |opts, args|
          puts opts.help_string
        end

        sub "start" do
          help short: "-h"
          usage "ct neph start"
          desc "start git trigger server"
          run do |opts, args|
            GitTrigger.start
          end
        end
      end

    end
  end
end

CrystalDo::Cli.start(ARGV)
