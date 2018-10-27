docker run -d -p 15000:15000 -v /home/buhman/work/:/work -w /work gcr.io/crucial-baton-168900/wesnoth /wesnothd -c /wesnothd.cfg

docker run -d -p 15014:15014 -v /home/buhman/work/:/work -w /work gcr.io/crucial-baton-168900/wesnoth /campaignd
