output "public_ip_of_demo_server"{
    description ="this is the Public IP"
    value= aws_instance.demo-server.public_ip
}