import numpy as np
import matplotlib.pyplot as plt
from scipy import constants

CONSTANTE_M = 2 # Masa del carro
CONSTANTE_m = 1 # Masa de la pertiga
CONSTANTE_l = 1 # Longitud dela pertiga

# Simula el modelo del carro-pendulo.
# Parametros:
#   t_max: tiempo maximo (inicia en 0)
#   delta_t: incremento de tiempo en cada iteracion
#   theta_0: Angulo inicial (grados)
#   v_0: Velocidad angular inicial (radianes/s)
#   a_0: Aceleracion angular inicial (radianes/s2)
def simular(t_max, delta_t, theta_0, v_0, a_0,angulos,vel,fuerzas):
  theta = (theta_0 * np.pi) / 180
  v = v_0
  a = a_0

  # Simular

  u=[]
  z=[]
  y = []
  x = np.arange(0, t_max, delta_t)
  for t in x:
    #print(angulos)
    [f,angulos,vel,fuerzas]=calcula_fuerza(theta,v,angulos,vel,fuerzas)
    a = calcula_aceleracion(theta, v, f)
    v = v + a * delta_t
    theta = theta + v * delta_t + a * np.power(delta_t, 2) / 2
    y.append(theta)
    z.append(v)
    u.append(a)
#tiempo- posicion
  fig, ax = plt.subplots()
  ax.plot(x, y)

  ax.set(xlabel='time (s)', ylabel='theta', title='Delta t = ' + str(delta_t) + " s")
  ax.grid()

#tiempo-velocidad
  fig, xz = plt.subplots()
  xz.plot(x, z)

  xz.set(xlabel='time (s)', ylabel='Vel theta', title='Delta t = ' + str(delta_t) + " s")
  xz.grid()
  
#tiempo-aceleracion
  fig, xz = plt.subplots()
  xz.plot(x, u)

  xz.set(xlabel='time (s)', ylabel='acel theta', title='Delta t = ' + str(delta_t) + " s")
  xz.grid()
  

  plt.show()


# Calcula la aceleracion en el siguiente instante de tiempo dado el angulo y la velocidad angular actual, y la fuerza ejercida
def calcula_aceleracion(theta, v, f):
    numerador = constants.g * np.sin(theta) + np.cos(theta) * ((-f - CONSTANTE_m * CONSTANTE_l * np.power(v, 2) * np.sin(theta)) / (CONSTANTE_M + CONSTANTE_m))
    denominador = CONSTANTE_l * (4/3 - (CONSTANTE_m * np.power(np.cos(theta), 2) / (CONSTANTE_M + CONSTANTE_m)))
    return numerador / denominador


def difusor(x, rango, medio):
  xm = medio
  x1 = xm + rango/2
  x2 = xm - rango/2
  y = 0
  if x > x1 or x < x2:
    return 0.0
  elif x > xm:
    y = x*(1)/(xm - x1) - xm/(xm-x1) +1
  elif x < xm:
    y = -x*1/(x2 - xm) + x2/(x2-xm)
  elif x == xm:
    y = 1
  return y

def difusorDer(x, rango, medio):
  xm = medio
  x1 = xm + rango/2
  x2 = xm - rango/2
  y = 0
  if x > x1 or x < x2:
    return 0.0
  elif x > xm:
    y = 1
  elif x < xm:
    y = -x*1/(x2 - xm) + x2/(x2-xm)
  return y

def difusorIzq(x, rango, medio):
  xm = medio
  x1 = xm + rango/2
  x2 = xm - rango/2
  y = 0
  if x > x1 or x < x2:
    return 0.0
  elif x > xm:
    y = x*(1)/(xm - x1) - xm/(xm-x1) +1
  elif x < xm:
    y = 1
  return y


def calcula_fuerza(theta,v,angulos,vel,fuerzas):
  f=0
  angDif=""
  velDif=""
  fDif=""
  if(theta<angulos["NG"]):
    angDif="NG"
  elif (angulos["NG"]<theta<angulos["NP"]):
    angDif="NP"
  elif (angulos["NP"]<theta<angulos["Z"]):
    angDif="Z"
  elif (angulos["Z"]<theta<angulos["PP"]):
    angDif="Z"
  elif (angulos["PP"]<theta<angulos["PG"]):
    angDif="PP"
  elif (theta>angulos["PG"]):
    angDif="PG"

  if(v<vel["NG"]):
    velDif="NG"
  elif (vel["NG"]<v<vel["NP"]):
    velDif="NP"
  elif (vel["NP"]<v<vel["Z"]):
    velDif="Z"
  elif (vel["Z"]<v<vel["PP"]):
    velDif="Z"
  elif (vel["PP"]<v<vel["PG"]):
    velDif="PP"
  elif (v>vel["PG"]):
    velDif="PG"
  
  #print(angDif,velDif)
  #tabla FAM
  #ang NG
  if((angDif=="NG")and(velDif=="NG")):
    fDif="PG"
  if((angDif=="NG")and(velDif=="NP")):
    fDif="PG"
  if((angDif=="NG")and(velDif=="Z")):
    fDif="PG"
  if((angDif=="NG")and(velDif=="PP")):
    fDif="PP"
  if((angDif=="NG")and(velDif=="PG")):
    fDif="Z"
  #ang NP
  if((angDif=="NP")and(velDif=="NG")):
    fDif="PG"
  if((angDif=="NP")and(velDif=="NP")):
    fDif="PG"
  if((angDif=="NP")and(velDif=="Z")):
    fDif="PP"
  if((angDif=="NP")and(velDif=="PP")):
    fDif="Z"
  if((angDif=="NP")and(velDif=="PG")):
    fDif="NP"
  #ang Z
  if((angDif=="Z")and(velDif=="NG")):
    fDif="PG"
  if((angDif=="Z")and(velDif=="NP")):
    fDif="PP"
  if((angDif=="Z")and(velDif=="Z")):
    fDif="Z"
  if((angDif=="Z")and(velDif=="PP")):
    fDif="NP"
  if((angDif=="Z")and(velDif=="PG")):
    fDif="NG"

  #ang PP
  if((angDif=="PP")and(velDif=="NG")):
    fDif="PP"
  if((angDif=="PP")and(velDif=="NP")):
    fDif="Z"
  if((angDif=="PP")and(velDif=="Z")):
    fDif="NP"
  if((angDif=="PP")and(velDif=="PP")):
    fDif="NG"
  if((angDif=="PP")and(velDif=="PG")):
    fDif="NG"
    
  if((angDif=="PG")and(velDif=="NG")):
    fDif="Z"
  if((angDif=="PG")and(velDif=="NP")):
    fDif="NP"
  if((angDif=="PG")and(velDif=="Z")):
    fDif="NG"
  if((angDif=="PG")and(velDif=="PP")):
    fDif="NG"
  if((angDif=="PG")and(velDif=="PG")):
    fDif="NG"
  
  angulos2 = {"NG":difusorDer(theta,angulos["PG"],angulos["NG"]), "NP":difusor(theta,angulos["PG"],angulos["NP"]), "Z":difusor(theta,angulos["PG"],angulos["Z"]), "PP":difusor(theta,angulos["PG"],angulos["PP"]),"PG": difusorDer(theta,angulos["PG"],angulos["PG"])} 
  vel2 = {"NG":difusorDer(v,vel["PG"],vel["NG"]), "NP":difusor(v,vel["PG"],vel["NP"]), "Z":difusor(v,vel["PG"],vel["Z"]), "PP":difusor(v,vel["PG"],vel["PP"]),"PG": difusorDer(v,vel["PG"],vel["PG"])}
  #fuerzas2 = {"NG":difusorDer(theta,10,-10), "NP":difusor(theta,10,-5), "Z":difusor(theta,10,0), "PP":difusor(theta,10,5),"PG": difusorDer(theta,10,10)}
  
  if(fDif==""):
    f=0
  else:
    f=fuerzas[fDif]

  angulos=angulos2
  vel=vel2
  return [f,angulos,vel,fuerzas]

#simular(10, 0.1, 45, 0, 0)

#simular(10, 0.01, 45, 0, 0)
angulos = {"NG":-10, "NP":-5, "Z":0, "PP":5,"PG": 10} 
vel = {"NG":-6, "NP":-3, "Z":0, "PP":3, "PG":6}
fuerzas = {"NG":-10, "NP":-5, "Z":0, "PP":5, "PG":10} 
simular(10, 0.001, 45, 0, 0,angulos,vel,fuerzas) #tmax, deltat,thetaini,velini,acelini
#print(angulos["NG"])
#simular(10, 0.0001, 45, 0, 0)


