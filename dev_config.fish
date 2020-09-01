# Path Variables
set -a PATH /home/linuxbrew/.linuxbrew/bin
for f in envImprovement AmazonAwsCli OdinTools
    if -d '/apollo/env/$f'
        set -a PATH '/apollo/env/$f/bin'
    end
end