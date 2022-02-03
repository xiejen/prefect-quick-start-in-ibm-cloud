This is an example of how to run a flow in a kubernetes cluster on IBM Cloud.

The `setup.py` is to make this a module so that I can import the components. Use `pip install -e .` to install your module in the Docker image.

Steps

1. Build the Docker image and run the workflow in the Docker container locally

Build the Docker image with `docker build . -t test:latest`
docker run --name mycontainername -i -t test:latest sh
python flow.py
exit

2. prepare Kubernetes cluster for the flow
Log in to your account. If applicable, target the appropriate resource group. Set the context for your cluster.
_$ibmcloud ks cluster config -c c5arhlof03sl2gfv1k1g
$ibmcloud target -g rfp-analyzer_
create a namespace
_$kubectl create namespace prefect-demo_
copy the imagePullSecret from default namespace  (By using the default cluster setup, you can deploy containers from any image that is stored in your IBM Cloud Container Registry namespace into the default Kubernetes namespace of your cluster. To use these images in any other Kubernetes namespaces or other IBM Cloud accounts, you have the option to copy or create your own image pull secrets.)
_$ kubectl get secret all-icr-io -n default -o yaml | sed 's/default/<new-namespace>/g' | kubectl create -n <new-namespace> -f -   
$ kubectl get secret all-icr-io -n default -o yaml | sed 's/default/prefect-demo/g' | kubectl create -n prefect-demo -f - _   
 Confirm imagePullSecret is created
_$kubectl get secrets -n prefect-demo | grep icr-io_

Use prefect register to push image to icr.
you need to login to IBM Container Registry from a terminal session, 
ibmcloud cr login 
    in this step, if it doesn't reponse with Logged in to 'de.icr.io', do this : docker login -u iamapikey -p I-zYsAEvtJq0HNH_dXPvYnK4St525mtMXEWwSlYn69v0 de.icr.io
and from the same session you run:
 $ prefect register --project prefect-demo -p flow.py
ibmcloud cr login 
    in this step, if it doesn't reponse with de.icr.io, do this : docker login -u iamapikey -p I-zYsAEvtJq0HNH_dXPvYnK4St525mtMXEWwSlYn69v0 de.icr.io
login to https://cloud.prefect.io/ to create project "prefect-get-started"
$ prefect register --project prefect-get-started -p flow.py
if you see "command not found: prefect",  you need to install prefect in your virtual and activate the venv in your session

2. Register the flow with `python flow.py`
3. Start your agent with `prefect agent docker start`
4. Run the flow with a `Quick Run` from the UI
