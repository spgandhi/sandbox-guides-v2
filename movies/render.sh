echo "Usage: sh render.sh [publish]"
GUIDES=../neo4j-guides

function render {
  $GUIDES/run.sh $1 $2 "+1" $3
}

if [ "$1" == "publish" ]; then
  SANDBOX_URL=guides.neo4j.com/sandbox/movies
  AURA_URL=guides.neo4j.com/aura/movies
  render movies.adoc sandbox_index.html http://$SANDBOX_URL
  render movies.adoc aura_index.html http://$AURA_URL

  # Sandbox Guide Deployment
  aws s3 cp sandbox_index.html s3://$SANDBOX_URL/index.html
  aws s3 cp --acl public-read --recursive --exclude "*" --include "*.html" --include "*.png" --include "*.jpg" --include "*.gif" . s3://${SANDBOX_URL}/
  aws s3 cp --acl public-read index.html s3://${SANDBOX_URL}

  # Aura Guide Deployment
  aws s3 cp aura_index.html s3://$AURA_URL/index.html
  aws s3 cp --acl public-read --recursive --exclude "*" --include "*.html" --include "*.png" --include "*.jpg" --include "*.gif" . s3://${AURA_URL}/
  aws s3 cp --acl public-read index.html s3://${AURA_URL}
 
  echo "Publication Done"
elif [ "$1" == "render-only" ]; then
  SANDBOX_URL=guides.neo4j.com/sandbox/movies
  render http://$SANDBOX_URL
else
  SANDBOX_URL=localhost:8001/
  AURA_URL=localhost:8001/
  render movies.adoc sandbox_index.html http://$SANDBOX_URL
  render movies.adoc aura_index.html http://$AURA_URL
  echo "Starting Websever at $URL Ctrl-c to stop"
  python $GUIDES/http-server.py
fi
