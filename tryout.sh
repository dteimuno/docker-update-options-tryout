docker network create --driver overlay --attachable my-overlay
#constrain  to current  node
docker service  create --name firefly -p  80:80 --network  my-overlay --replicas 5 --constraint node.hostname==node1 bretfisher/browncoat:v1

#monitor for 15 seconds beforenext task(no-op)
docker service update --update-monitor 15s firefly
docker service inspect --pretty firefly
#update 5 at a time, force an update without changes
docker service scale firefly=15
docker service  update --force --update-parallelism 5 --force firefly
#start new container first before killing old one
docker service scale  firefly=1
docker service update --update-order start-first --force firefly