############################################################################
#      Ansible functions
############################################################################

function af () ( 
# Allows you to run ansible on an ad-hoc list of hosts you've put into your ~/hosts file. 
# You need to enable root as default user in your /etc/ansible/ansible.conf!
   ansible all -i $HOME/hosts -t ~/.AnsibleLogs -m shell -a "$1"
)

function afr () (
# Same as af, but using the "raw" module to be compatible with all OS. Cannot be used with async.
   ansible all -i $HOME/hosts -t ~/.AnsibleLogs -m raw -a "$1"
)


function ah () ( 
# Allows using ansible via list of (space/comma-separated) hosts on the command line. Usage ah [COMMAND] [HOSTS]
# You need to enable root as default user in your /etc/ansible.conf!
	HOSTS="${*:2}"
	HOSTS=${HOSTS//,}
	echo ${HOSTS}  |  tr " " "\n" >~/hosts
	af "$1"
)

function ahr () ( 
# Same as ah, but runs in a shell, instead of raw.
	HOSTS="${*:2}"
	HOSTS=${HOSTS//,}
	echo ${HOSTS}  |  tr " " "\n" >~/hosts
	afr "$1"
)


#Quick alias to be able to choose custom mod and custom hosts group.
alias ai="ansible-3 -i $TOOLS/unix/playbook/inventory.py -t ~/.AnsibleLogs"
alias ap="ansible-playbook"
