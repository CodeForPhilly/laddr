<?php

$roles = [
    'frontend' => 'Front-end Developer',
    'backend' => 'Back-end Developer',
    'fullstack' => 'Full Stack Engineer',
    'data-engineer' => 'Data Engineer',
    'data-analyst' => 'Data Scientist/Analyst',
    'devops' => 'DevOps Engineer',
    'product-manager' => 'Product Manager',
    'project-manager' => 'Project Manager',
    'ux' => 'UX/UI',
    'graphic-designer' => 'Graphic Designer',
];

$technologies = [
    'react' => 'React',
    'django' => 'Django',
    'vue' => 'Vue',
    'php' => 'PHP',
    'python' => 'Python',
    'r' => 'R',
    'git' => 'Git',
    'change-management' => 'Change Management',
    'pm' => 'Project Management Frameworks/Tools',
    'docker' => 'Docker',
    'javascript' => 'Javascript',
    'ux' => 'UX/UI',
    'wordpress' => 'WordPress',
];

RequestHandler::respond('questionnaire', [
    'roles' => $roles,
    'technologies' => $technologies
]);
