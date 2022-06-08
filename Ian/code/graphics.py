from OpenGL.GL import *
from ctypes import sizeof, c_void_p
import numpy as np

VERTEX_SHADER_SOURCE = '''
    #version 330 core
    layout (location = 0) in vec3 aPos;
    
    void main(){
        gl_Position = vec4(aPos, 1.0);
    }'''

FRAGMENT_SHADER_SOURCE = '''
    #version 330 core
    uniform int currBalls;
    
    uniform vec3 metaballs[300];
    uniform vec4 colors[300];
    const float threshold = 0.95;

    out vec4 fragColor;

    struct Metaball{
	    vec3 color;
	    vec2 position;
	    float radius;
    };

    Metaball createBall(vec4 color, vec3 ball){
        Metaball returnBall;
        returnBall.color = color.xyz;
        returnBall.position = vec2(ball.x , ball.y);
        returnBall.radius = ball.z;
        return returnBall;
    }

    void main(){
        vec3 fragCoord = vec3(gl_FragCoord.x, gl_FragCoord.y, 0);

	    vec3 col = vec3(0,0,0); 
	    float infl = 0.0;
	    for(int i = 0; i < currBalls; i++){
		    Metaball mb = createBall(colors[i], metaballs[i]);
		    float dist = length(fragCoord.xy - mb.position);
		    float currInfl = mb.radius * mb.radius;
		    currInfl /= (pow(abs(fragCoord.x-mb.position.x),2.0) + pow(abs(fragCoord.y-mb.position.y),2.0));
		    infl += currInfl;
		    col += mb.color*currInfl;
	    }
	    if(infl > threshold){
		    col = normalize(col);
        }
		
	    fragColor.xyz = col;
    }'''

#  (x, y, z)
_vertices = [-1, -1, 0,1, -1, 0,1,  1, 0,-1,  1, 0,0,]
_indecies = [0, 1, 2, 2, 3, 0]

#creating everything ever:
def _createShaders():
    program = glCreateProgram()
    _createShader(GL_VERTEX_SHADER, VERTEX_SHADER_SOURCE, program)
    _createShader(GL_FRAGMENT_SHADER, FRAGMENT_SHADER_SOURCE, program)
    glLinkProgram(program)
    glUseProgram(program)
    return program

def _createShader(shaderType, shaderSource, program):
    shader = glCreateShader(shaderType)
    glShaderSource(shader, shaderSource)
    glCompileShader(shader)
    glAttachShader(program, shader)
    return shader

def _createBuffer(data, target, usage):
    vbo = None
    vbo = glGenBuffers(1, vbo)
    glBindBuffer(target, vbo)
    glBufferData(target, sizeof(data), data, usage)
    return vbo

def _createVertexArray():
    vao = None
    vao = glGenVertexArrays(1, vao)
    glBindVertexArray(vao)
    glEnableVertexAttribArray(0)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), c_void_p(0))
    return vao

def setup():
    global _vao, _vertices, _indecies, _program
    _vertices = (GLfloat * len(_vertices))(*_vertices)
    _indecies= (GLuint * len(_indecies))(*_indecies)
    _program = _createShaders()
    _createBuffer(_vertices, GL_ARRAY_BUFFER, GL_STATIC_DRAW)
    _createBuffer(_indecies, GL_ELEMENT_ARRAY_BUFFER, GL_STATIC_DRAW)
    _vao = _createVertexArray()    
    
#uniforms:
def _getUniformLocation(name):
    uniformLocation = glGetUniformLocation(_program, name)
    if (uniformLocation == -1):
        print( 'Can not find uniform ' + name + '.')
    return uniformLocation

def setUniform1f(name, value):
    glUniform1f(_getUniformLocation(name), GLfloat(value))
def setUniform1i(name, value):
    glUniform1i(_getUniformLocation(name), GLint(value))

#drawing:
def drawBalls(data, balls):
    glLinkProgram(_program) #dit is wat je noemt een hack.
    setUniform1i("currBalls", balls)
    count = len(data[0]) / 3
    count2 = len(data[1]) / 4
 
    glUniform3fv(_getUniformLocation("metaballs"), int(count), np.array(data[0]))
    glUniform4fv(_getUniformLocation("colors"), int(count2), np.array(data[1]))
    glDrawElements(GL_TRIANGLES, len(_indecies), GL_UNSIGNED_INT, _indecies)