import yaml

def convert_reqtxt_to_yaml(req_txt_file, yaml_file):
    with open(req_txt_file, 'r') as file:
        lines = file.readlines()

    dependencies = []
    pip_dependencies = []

    for line in lines:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if 'pypi' in line:
            pip_dependencies.append(line.split('=')[0] + '==' + line.split('=')[1])
        else:
            dependencies.append(line)

    if pip_dependencies:
        dependencies.append({'pip': pip_dependencies})

    env_dict = {
        'name': 'myenv',
        'channels': ['defaults'],
        'dependencies': dependencies
    }

    with open(yaml_file, 'w') as file:
        yaml.dump(env_dict, file, default_flow_style=False)

    print(f"Conversion complete! '{yaml_file}' file has been created.")

# Replace 'req.txt' with the path to your actual req.txt file
convert_reqtxt_to_yaml('req.txt', 'environment.yaml')

import yaml

# Load the environment.yaml file
with open('environment.yaml', 'r') as file:
    env = yaml.safe_load(file)

# Extract the dependencies
dependencies = env['dependencies']

# Create a list for pip requirements
pip_requirements = []

# Loop through the dependencies and convert them
for dep in dependencies:
    if isinstance(dep, str):
        pip_requirements.append(dep)
    elif isinstance(dep, dict) and 'pip' in dep:
        pip_requirements.extend(dep['pip'])

# Write the pip requirements to requirements.txt
with open('requirements.txt', 'w') as file:
    for req in pip_requirements:
        file.write(req + '\n')

print("Conversion complete! 'requirements.txt' file has been created.")
