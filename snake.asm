#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas nécessaire de les modifier.!!!

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff, 0x000000ff, 0x00fc5900, 0x00ffff00, 0x0000A86B, 0x00FF5D94, 0x00808380
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16
.eqv blue  20
.eqv orange 24
.eqv yellow 28
.eqv ErmColor 32
.eqv DebColor 36
.eqv BothColor 40

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: 
bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  mul $a0 $s1 42949 #171798
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
or $t0 0x2
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:
bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 122
beq $t0 $t1 GIhaut
li $t1 115
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

#jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
lw $a0 speedSnake
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
speedSnake:    .word 460       # Vitesse du serpent 

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire un demi-tour 
#                 (se retourner en un seul tour. Par exemple passer de la 
#                 direction droite à gauche directement est impossible (un 
#                 serpent n'est pas une chouette)
################################################################################

majDirection:
lw $t1 snakeDir		# enregistrement de la direction actuelle du serpent 
lw $t2 snakeDir 	# dans le cas ou il n'y a pas de changement de direction
beq $a0 0 majHaut 	# touche Z press�e
beq $a0 1 majDroite 	# touche D press�e
beq $a0 2 majBas 	# touche S press�e
beq $a0 3 majGauche 	# touche Q press�e
j majEnd


majHaut:		# mise a jour direction haut pour le serpent
beq $t1 2 majEnd 	# si la direction actuelle est contraire a la direction � set, pas de changement, saut � la fin
li $t2 0 		# sinon enregistre la nouvelle direction dans $t2
j majEnd		

majDroite:
beq $t1 3 majEnd
li $t2 1
j majEnd

majBas: 
beq $t1 0 majEnd
li $t2 2
j majEnd

majGauche:
beq $t1 1 majEnd 
li $t2 3
j majEnd

majEnd:
sw $t2 snakeDir 	#met a jour la direction du serpent avec le contenu de $t2
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
subu $sp $sp 4
sw $ra ($sp)

updateSnakePos:
lw $t0 tailleSnake	# charge la taille actuelle du serpent dans $t0
addi $t0 $t0 -1		# enleve 1 � cette taille car la tete se trouve en position 0
sll $t0 $t0 2		# multiplication de la taille par 4 pour acceder aux coordonnees X,Y du serpent dans la boucle

USPLoop:
beqz $t0 moveSnake	# sort de la boucle une fois avoir mis a jour tout le corps sans la tete
addi $t0 $t0 -4		
lw $t1 snakePosX($t0)	# charge dans $t1 la coordonnee X � la taille - 1 
lw $t2 snakePosY($t0)	# charge dans $t2 la coordonnee Y � la taille - 1
addi $t0 $t0 4
sw $t1 snakePosX($t0)	# sauvegarde le contenu de $t1 � la coordonnee X de la taille
sw $t2 snakePosY($t0)	# sauvegarde le contenu de $t2 � la coordonnee Y de la taille
addi $t0 $t0 -4
j USPLoop


moveSnake:
lw $t0 snakeDir
lw $t1 snakePosX
lw $t2 snakePosY
beq $t0 0 moveHaut	# direction haut
beq $t0 1 moveDroite	# direction droite
beq $t0 2 moveBas	# direction bas
beq $t0 3 moveGauche	# direction gauche
j moveEnd

moveHaut:
addi $t1 $t1 -1		# deplace la tete d'1 case vers la direction demandee
sw $t1 snakePosX	# enregistre cette valeur pour le bon coordonnee
j moveEnd

moveDroite: 
addi $t2 $t2 1
sw $t2 snakePosY
j moveEnd

moveBas: 
addi $t1 $t1 1
sw $t1 snakePosX
j moveEnd

moveGauche:
addi $t2 $t2 -1
sw $t2 snakePosY
j moveEnd

# Tester si le serpent a mang� le bonbon
moveEnd:
lw $t1 snakePosX($0)
lw $t2 snakePosY($0)
lw $t3 candy
lw $t4 candy + 4

beq $t1 $t3 sameY	# si les coordonnees X du bonbon et du serpent sont similaires, saut vers sameY
j updateEnd		# sinon fin de la mise a jour du jeu

sameY:
beq $t2 $t4 bonbonMange # si les coordonnees X du bonbon et du serpent sont similaires, le bonbon a ete mange, saut vers bonbonMange
j updateEnd		# sinon fin de la mise a jour du jeu


# LE BONBON A ETE MANGE 
bonbonMange:
jal newRandomObjectPosition 	# ajout d'un nouveau bonbon avec coordonnees aleatoires
sw $v0 candy
sw $v1 candy + 4

lw $t5 scoreJeu			
addi $t5 $t5 1			# incrementation du score
sw $t5 scoreJeu 

lw $t6 speedSnake
addi $t6 $t6 -20		# augmentation de la vitesse du serpent
sw $t6 speedSnake

lw $t5 numObstacles
addi $t5 $t5 1			# ajout d'un nouvel obstacle
sw $t5 numObstacles
#emplacement du nouvel obstacle
addi $t5 $t5 -1			# enleve 1 au nombre d'obstacles car le premier se trouve en position 0
sll $t5 $t5 2			# multiplication de la taille par 4 pour acceder aux coordonnees X,Y du dernier obstacle
jal newRandomObjectPosition	# genere des coordonnees aleatoires pour le nouvel obstacles 
sw $v0 obstaclesPosX($t5)
sw $v1 obstaclesPosY($t5)


lw $t6 tailleSnake
addi $t6 $t6 1			# augmente la taille du serpent de 1
sw $t6 tailleSnake
addi $t6 $t6 -1			# enleve 1 � la taille du serpent car la tete se trouve en position 0
sll $t6 $t6 2			# multiplication de la taille par 4 pour acceder aux coordonnees X,Y du serpent dans la boucle
lw $t1 lastSnakePiece		# charge le dernier point X connu de la queue dans $t1 
lw $t2 lastSnakePiece + 4	# charge le dernier point Y connu de la queue dans $t1
sw $t1 snakePosX($t6)		# sauvegarde ce point X pour la nouvelle queue
sw $t2 snakePosY($t6)		# sauvegarde ce point Y pour la nouvelle queue

updateEnd:
lw $ra ($sp)
addu $sp $sp 4
jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
li $v0 0		# $v0 = 0, le jeu continue
lw $t1 snakePosX
lw $t2 snakePosY
li $t3 15		# valeur max pour les coordonnes X et Y du serpent


collisionGrille:
bgt $t1 $t3 collision   # collision parroi haut
bltz $t1 collision	# collision parroi bas
bgt $t2 $t3 collision	# collision parroi droite
bltz $t2 collision	# collision parroi gauche

collisionObstacle:
lw $t7 numObstacles	
sll $t7 $t7 2
li $s0 0

COLoop:
bge $s0 $t7 collisionSnake #fait la verification pour chaque obstacle 	
lw $t5 obstaclesPosX($s0)
lw $t6 obstaclesPosY($s0)
beq $t1 $t5 PosYobs	# verifie si la tete et l'obstacle ont la meme coordonnee X, si c'est le cas saute vers PosYobs
addu $s0 $s0 4		# sinon obstacle suivant
j COLoop

PosYobs:
beq $t2 $t6 collision   # si la tete et l'obstacle compare en X ont aussi la meme coordonne Y, alors collision
addu $s0 $s0 4		# sinon obstacle suivant
j COLoop

#cogne queue
collisionSnake:
lw $t7 tailleSnake 
sll $t7 $t7 2
li $t8 4

CSLoop:
ble $t7 $t8 endConditionFinJeu  #fait la verification pour chaque partie du serpent	
lw $t5 snakePosX($t7)
lw $t6 snakePosY($t7)
beq $t1 $t5 PosYsnake	# verifie si la tete et une partie de son corps ont la meme coordonnee X, si c'est le cas saute vers PosYobs
addi $t7 $t7 -4		# partie du corps suivant
j CSLoop

PosYsnake:
beq $t2 $t6 collision	# si la tete et la partie du corps compare en X ont aussi la meme coordonne Y, alors collision
addi $t7 $t7 -4		# sinon obstacle suivant
j CSLoop

collision:
li $v0 1		# $v0 = 0, le jeu s'arrete

endConditionFinJeu:
jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyafvndjnifnieniprestation!»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
subu $sp $sp 4
sw $ra ($sp)

jal resetAffichage

lw $t6 scoreJeu
li $t4 10
div $t6 $t4 
mfhi $t7 	# enregistre la dizaine du score dans $t7
mflo $t8	# enregistre l'unite du score dans $t8

li $t4 4	# couleur de debut
li $t5 32	# couleur de fin

j loopGameOver


scoreD:		# affiche la dizaine du score
lw $a0 colors($t4)
beq $t8 0 zeroD
beq $t8 1 unD
beq $t8 2 deuxD

scoreU:		#affiche l'unite du score
beq $t7 0 zeroU
beq $t7 1 unU
beq $t7 2 deuxU
beq $t7 3 troisU
beq $t7 4 quatreU
beq $t7 5 cinqU
beq $t7 6 sixU
beq $t7 7 septU
beq $t7 8 huitU
beq $t7 9 neufU

loopGameOver:

lw $t0 0xffff0004
li $t1 114		# code ASCII pour 'r'
beq $t0 $t1 reset	# si l'utilisateur appuie sur 'r', recommence la partie

beq $t5 $t4 creditsFinJeu

#G
lw $a0 colors($t4)
li $a1 1
li $a2 2
jal printColorAtPosition
li $a1 1
li $a2 3
jal printColorAtPosition
li $a1 1
li $a2 4
jal printColorAtPosition
li $a1 1
li $a2 5
jal printColorAtPosition
li $a1 2
li $a2 6
jal printColorAtPosition
li $a1 2
li $a2 1
jal printColorAtPosition
li $a1 3
li $a2 1
jal printColorAtPosition
li $a1 4
li $a2 1
jal printColorAtPosition
li $a1 5
li $a2 1
jal printColorAtPosition
li $a1 6
li $a2 2
jal printColorAtPosition
li $a1 6
li $a2 3
jal printColorAtPosition
li $a1 6
li $a2 4
jal printColorAtPosition
li $a1 6
li $a2 5
jal printColorAtPosition
li $a1 5
li $a2 6
jal printColorAtPosition
li $a1 4
li $a2 6
jal printColorAtPosition
li $a1 4
li $a2 5
jal printColorAtPosition
li $a1 4
li $a2 4
jal printColorAtPosition

#A
li $a1 1
li $a2 10
jal printColorAtPosition
li $a1 1
li $a2 11
jal printColorAtPosition
li $a1 1
li $a2 12
jal printColorAtPosition
li $a1 1
li $a2 13
jal printColorAtPosition
li $a1 2
li $a2 9
jal printColorAtPosition
li $a1 3
li $a2 9
jal printColorAtPosition
li $a1 4
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 9
jal printColorAtPosition
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 2
li $a2 14
jal printColorAtPosition
li $a1 3
li $a2 14
jal printColorAtPosition
li $a1 4
li $a2 14
jal printColorAtPosition
li $a1 5
li $a2 14
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 4
li $a2 10
jal printColorAtPosition
li $a1 4
li $a2 11
jal printColorAtPosition
li $a1 4
li $a2 12
jal printColorAtPosition
li $a1 4
li $a2 13
jal printColorAtPosition

#M
li $a1 9
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 1
jal printColorAtPosition
li $a1 11
li $a2 1
jal printColorAtPosition
li $a1 12
li $a2 1
jal printColorAtPosition
li $a1 13
li $a2 1
jal printColorAtPosition
li $a1 14
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 2
jal printColorAtPosition
li $a1 11
li $a2 3
jal printColorAtPosition
li $a1 11
li $a2 4
jal printColorAtPosition
li $a1 10
li $a2 5
jal printColorAtPosition
li $a1 9
li $a2 6
jal printColorAtPosition
li $a1 10
li $a2 6
jal printColorAtPosition
li $a1 11
li $a2 6
jal printColorAtPosition
li $a1 12
li $a2 6
jal printColorAtPosition
li $a1 13
li $a2 6
jal printColorAtPosition
li $a1 14
li $a2 6
jal printColorAtPosition

#E
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 9
jal printColorAtPosition
li $a1 11
li $a2 9
jal printColorAtPosition
li $a1 12
li $a2 9
jal printColorAtPosition
li $a1 13
li $a2 9
jal printColorAtPosition
li $a1 14
li $a2 9
jal printColorAtPosition
li $a1 9
li $a2 10
jal printColorAtPosition
li $a1 9
li $a2 11
jal printColorAtPosition
li $a1 9
li $a2 12
jal printColorAtPosition
li $a1 9
li $a2 13
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 11
li $a2 10
jal printColorAtPosition
li $a1 11
li $a2 11
jal printColorAtPosition
li $a1 11
li $a2 12
jal printColorAtPosition
li $a1 11
li $a2 13
jal printColorAtPosition
li $a1 14
li $a2 10
jal printColorAtPosition
li $a1 14
li $a2 11
jal printColorAtPosition
li $a1 14
li $a2 12
jal printColorAtPosition
li $a1 14
li $a2 13
jal printColorAtPosition
li $a1 14
li $a2 14
jal printColorAtPosition

#supprimer
li $a0 1500
jal sleepMillisec
jal resetAffichage

#O
lw $a0 colors($t4)
li $a1 1
li $a2 2
jal printColorAtPosition
li $a1 1
li $a2 3
jal printColorAtPosition
li $a1 1
li $a2 4
jal printColorAtPosition
li $a1 1
li $a2 5
jal printColorAtPosition
li $a1 2
li $a2 6
jal printColorAtPosition
li $a1 3
li $a2 6
jal printColorAtPosition
li $a1 4
li $a2 6
jal printColorAtPosition
li $a1 5
li $a2 6
jal printColorAtPosition
li $a1 2
li $a2 1
jal printColorAtPosition
li $a1 3
li $a2 1
jal printColorAtPosition
li $a1 4
li $a2 1
jal printColorAtPosition
li $a1 5
li $a2 1
jal printColorAtPosition
li $a1 6
li $a2 2
jal printColorAtPosition
li $a1 6
li $a2 3
jal printColorAtPosition
li $a1 6
li $a2 4
jal printColorAtPosition
li $a1 6
li $a2 5
jal printColorAtPosition


#V
li $a1 1
li $a2 9
jal printColorAtPosition
li $a1 2
li $a2 9
jal printColorAtPosition
li $a1 3
li $a2 9
jal printColorAtPosition
li $a1 4
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 6
li $a2 11
jal printColorAtPosition
li $a1 6
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 1
li $a2 14
jal printColorAtPosition
li $a1 2
li $a2 14
jal printColorAtPosition
li $a1 3
li $a2 14
jal printColorAtPosition
li $a1 4
li $a2 14
jal printColorAtPosition


#E
li $a1 9
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 1
jal printColorAtPosition
li $a1 11
li $a2 1
jal printColorAtPosition
li $a1 12
li $a2 1
jal printColorAtPosition
li $a1 13
li $a2 1
jal printColorAtPosition
li $a1 14
li $a2 1
jal printColorAtPosition
li $a1 9
li $a2 2
jal printColorAtPosition
li $a1 9
li $a2 3
jal printColorAtPosition
li $a1 9
li $a2 4
jal printColorAtPosition
li $a1 9
li $a2 5
jal printColorAtPosition
li $a1 9
li $a2 6
jal printColorAtPosition
li $a1 14
li $a2 2
jal printColorAtPosition
li $a1 14
li $a2 3
jal printColorAtPosition
li $a1 14
li $a2 4
jal printColorAtPosition
li $a1 14
li $a2 5
jal printColorAtPosition
li $a1 14
li $a2 6
jal printColorAtPosition
li $a1 11
li $a2 2
jal printColorAtPosition
li $a1 11
li $a2 3
jal printColorAtPosition
li $a1 11
li $a2 4
jal printColorAtPosition
li $a1 11
li $a2 5
jal printColorAtPosition


#R
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 9
jal printColorAtPosition
li $a1 11
li $a2 9
jal printColorAtPosition
li $a1 12
li $a2 9
jal printColorAtPosition
li $a1 13
li $a2 9
jal printColorAtPosition
li $a1 14
li $a2 9
jal printColorAtPosition
li $a1 9
li $a2 10
jal printColorAtPosition
li $a1 9
li $a2 11
jal printColorAtPosition
li $a1 9
li $a2 12
jal printColorAtPosition
li $a1 9
li $a2 13
jal printColorAtPosition
li $a1 12
li $a2 10
jal printColorAtPosition
li $a1 12
li $a2 11
jal printColorAtPosition
li $a1 12
li $a2 12
jal printColorAtPosition
li $a1 12
li $a2 13
jal printColorAtPosition
li $a1 10
li $a2 14
jal printColorAtPosition
li $a1 11
li $a2 14
jal printColorAtPosition
li $a1 13
li $a2 13
jal printColorAtPosition
li $a1 14
li $a2 14
jal printColorAtPosition

li $a0 1000
jal sleepMillisec
jal resetAffichage
j scoreD

#0 dizaine
zeroD:
li $a1 5
li $a2 2
jal printColorAtPosition
li $a1 5
li $a2 3
jal printColorAtPosition
li $a1 5
li $a2 4
jal printColorAtPosition
li $a1 5
li $a2 5
jal printColorAtPosition
li $a1 6
li $a2 1
jal printColorAtPosition
li $a1 7
li $a2 1
jal printColorAtPosition
li $a1 8
li $a2 1
jal printColorAtPosition
li $a1 9
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 2
jal printColorAtPosition
li $a1 10
li $a2 3
jal printColorAtPosition
li $a1 10
li $a2 4
jal printColorAtPosition
li $a1 10
li $a2 5
jal printColorAtPosition
li $a1 6
li $a2 6
jal printColorAtPosition
li $a1 7
li $a2 6
jal printColorAtPosition
li $a1 8
li $a2 6
jal printColorAtPosition
li $a1 9
li $a2 6
jal printColorAtPosition
li $a1 9
li $a2 2
jal printColorAtPosition
li $a1 8
li $a2 3
jal printColorAtPosition
li $a1 7
li $a2 4
jal printColorAtPosition
li $a1 6
li $a2 5
jal printColorAtPosition
j scoreU

unD:
li $a1 10
li $a2 2
jal printColorAtPosition
li $a1 10
li $a2 3
jal printColorAtPosition
li $a1 10
li $a2 4
jal printColorAtPosition
li $a1 10
li $a2 5
jal printColorAtPosition
li $a1 10
li $a2 6
jal printColorAtPosition
li $a1 9
li $a2 4
jal printColorAtPosition
li $a1 8
li $a2 4 
jal printColorAtPosition
li $a1 7
li $a2 4
jal printColorAtPosition
li $a1 6
li $a2 4
jal printColorAtPosition
li $a1 5
li $a2 4
jal printColorAtPosition
li $a1 6
li $a2 3
jal printColorAtPosition
li $a1 7
li $a2 2
jal printColorAtPosition
j scoreU

deuxD:
li $a1 6
li $a2 1
jal printColorAtPosition
li $a1 5
li $a2 2
jal printColorAtPosition
li $a1 5
li $a2 3
jal printColorAtPosition
li $a1 5
li $a2 4
jal printColorAtPosition
li $a1 5
li $a2 5
jal printColorAtPosition
li $a1 6
li $a2 6
jal printColorAtPosition
li $a1 7
li $a2 6 
jal printColorAtPosition
li $a1 8
li $a2 5
jal printColorAtPosition
li $a1 8
li $a2 4
jal printColorAtPosition
li $a1 8
li $a2 3
jal printColorAtPosition
li $a1 8
li $a2 2
jal printColorAtPosition
li $a1 9
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 1
jal printColorAtPosition
li $a1 10
li $a2 2
jal printColorAtPosition
li $a1 10
li $a2 3
jal printColorAtPosition
li $a1 10
li $a2 4
jal printColorAtPosition
li $a1 10
li $a2 5
jal printColorAtPosition
li $a1 10
li $a2 6
jal printColorAtPosition
j scoreU



zeroU:
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 7
li $a2 9
jal printColorAtPosition
li $a1 8
li $a2 9
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 14
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 10
jal printColorAtPosition
li $a1 8
li $a2 11
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 6
li $a2 13
jal printColorAtPosition
j endScore


unU:
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 10
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 12
jal printColorAtPosition
li $a1 8
li $a2 12
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 6
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 6
li $a2 11
jal printColorAtPosition
li $a1 7
li $a2 10
jal printColorAtPosition
j endScore

deuxU:
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 14
jal printColorAtPosition
li $a1 8
li $a2 13
jal printColorAtPosition
li $a1 8
li $a2 12
jal printColorAtPosition
li $a1 8
li $a2 11
jal printColorAtPosition
li $a1 8
li $a2 10
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 10
li $a2 14
jal printColorAtPosition
j endScore

troisU:
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 13
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
j endScore

quatreU:
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 9
li $a2 10  
jal printColorAtPosition
li $a1 9
li $a2 11  
jal printColorAtPosition
li $a1 9
li $a2 12  
jal printColorAtPosition
li $a1 9
li $a2 13  
jal printColorAtPosition
li $a1 9
li $a2 14  
jal printColorAtPosition
li $a1 5
li $a2 13  
jal printColorAtPosition
li $a1 6
li $a2 13  
jal printColorAtPosition
li $a1 7
li $a2 13  
jal printColorAtPosition
li $a1 8
li $a2 13  
jal printColorAtPosition
li $a1 9
li $a2 13  
jal printColorAtPosition
li $a1 10
li $a2 13  
jal printColorAtPosition
li $a1 6
li $a2 12  
jal printColorAtPosition
li $a1 7
li $a2 11  
jal printColorAtPosition
li $a1 8
li $a2 10  
jal printColorAtPosition
j endScore

cinqU:
li $a1 5
li $a2 14
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 9
jal printColorAtPosition
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 7
li $a2 9
jal printColorAtPosition
li $a1 7
li $a2 10
jal printColorAtPosition
li $a1 7
li $a2 11
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 7
li $a2 13
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
j endScore

sixU:
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 7
li $a2 13
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 7
li $a2 11
jal printColorAtPosition
li $a1 7
li $a2 10
jal printColorAtPosition
li $a1 7
li $a2 9
jal printColorAtPosition
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 8
li $a2 9
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
j endScore

septU:
li $a1 5
li $a2 14
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 9
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 13
jal printColorAtPosition
li $a1 8
li $a2 12
jal printColorAtPosition
li $a1 9
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
j endScore

huitU:
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 13
jal printColorAtPosition
li $a1 7
li $a2 12
jal printColorAtPosition
li $a1 7
li $a2 11
jal printColorAtPosition
li $a1 7
li $a2 10
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 9
li $a2 9
jal printColorAtPosition
li $a1 8
li $a2 9
jal printColorAtPosition
j endScore

neufU:
li $a1 6
li $a2 9
jal printColorAtPosition
li $a1 7
li $a2 9
jal printColorAtPosition
li $a1 5
li $a2 10
jal printColorAtPosition
li $a1 5
li $a2 11
jal printColorAtPosition
li $a1 5
li $a2 12
jal printColorAtPosition
li $a1 5
li $a2 13
jal printColorAtPosition
li $a1 6
li $a2 14
jal printColorAtPosition
li $a1 7
li $a2 14
jal printColorAtPosition
li $a1 8
li $a2 14
jal printColorAtPosition
li $a1 9
li $a2 14
jal printColorAtPosition
li $a1 10
li $a2 10
jal printColorAtPosition
li $a1 10
li $a2 11
jal printColorAtPosition
li $a1 10
li $a2 12
jal printColorAtPosition
li $a1 10
li $a2 13
jal printColorAtPosition
li $a1 8
li $a2 13
jal printColorAtPosition
li $a1 8
li $a2 10
jal printColorAtPosition
li $a1 8
li $a2 11
jal printColorAtPosition
li $a1 8
li $a2 12
jal printColorAtPosition


endScore:
li $a0 1500
jal sleepMillisec
jal resetAffichage
addi $t4 $t4 4
j loopGameOver

################################ creditsFinJeu #################################

creditsFinJeu:
li $t8 15

loopCredits:
beq $t8 -22 endCredits
#Affichage : Erm
lw $a0 colors + ErmColor
#E
li $a1 1
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 1
add $a1 $a1 $t8
li $a2 1
jal printColorAtPosition
li $a1 1
add $a1 $a1 $t8
li $a2 2
jal printColorAtPosition
li $a1 1
add $a1 $a1 $t8
li $a2 3
jal printColorAtPosition
li $a1 1
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
li $a1 2
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 1
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 2
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 3
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 5
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 1
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 2
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 3
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
#r
li $a1 3
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 8
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 9
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 7
jal printColorAtPosition
li $a1 5
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
#m
li $a1 3
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 5
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 12
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 13
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 13
jal printColorAtPosition
li $a1 5
add $a1 $a1 $t8
li $a2 13
jal printColorAtPosition
li $a1 3
add $a1 $a1 $t8
li $a2 14
jal printColorAtPosition
li $a1 4
add $a1 $a1 $t8
li $a2 15
jal printColorAtPosition
li $a1 5
add $a1 $a1 $t8
li $a2 15
jal printColorAtPosition
li $a1 6
add $a1 $a1 $t8
li $a2 15
jal printColorAtPosition


#Affichage : &
lw $a0 colors + BothColor
li $a1 9
add $a1 $a1 $t8  
li $a2 6
jal printColorAtPosition
li $a1 9
add $a1 $a1 $t8  
li $a2 7
jal printColorAtPosition
li $a1 10
add $a1 $a1 $t8  
li $a2 5
jal printColorAtPosition
li $a1 10
add $a1 $a1 $t8  
li $a2 8
jal printColorAtPosition
li $a1 11
add $a1 $a1 $t8  
li $a2 7
jal printColorAtPosition
li $a1 11
add $a1 $a1 $t8  
li $a2 6
jal printColorAtPosition
li $a1 12
add $a1 $a1 $t8  
li $a2 5
jal printColorAtPosition
li $a1 13
add $a1 $a1 $t8  
li $a2 5
jal printColorAtPosition
li $a1 14
add $a1 $a1 $t8  
li $a2 6
jal printColorAtPosition
li $a1 14
add $a1 $a1 $t8  
li $a2 7
jal printColorAtPosition
li $a1 14
add $a1 $a1 $t8  
li $a2 8
jal printColorAtPosition
li $a1 12
add $a1 $a1 $t8  
li $a2 8
jal printColorAtPosition
li $a1 13
add $a1 $a1 $t8  
li $a2 9
jal printColorAtPosition
li $a1 12
add $a1 $a1 $t8  
li $a2 10
jal printColorAtPosition
li $a1 14
add $a1 $a1 $t8  
li $a2 10
jal printColorAtPosition

#Affichage : Deb
lw $a0 colors + DebColor
#D
li $a1 16
add $a1 $a1 $t8  
li $a2 0
jal printColorAtPosition
li $a1 17
add $a1 $a1 $t8  
li $a2 0
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8  
li $a2 0
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8 
li $a2 0
jal printColorAtPosition
li $a1 20
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 0
jal printColorAtPosition
li $a1 16
add $a1 $a1 $t8
li $a2 1
jal printColorAtPosition
li $a1 16
add $a1 $a1 $t8
li $a2 2
jal printColorAtPosition
li $a1 16
add $a1 $a1 $t8
li $a2 3
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 1
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 2
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8  
li $a2 3
jal printColorAtPosition
li $a1 17
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
li $a1 20
add $a1 $a1 $t8
li $a2 4
jal printColorAtPosition
#e
li $a1 17
add $a1 $a1 $t8
li $a2 7
jal printColorAtPosition
li $a1 17
add $a1 $a1 $t8
li $a2 8
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 9
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 7
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 8
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 9
jal printColorAtPosition
li $a1 20
add $a1 $a1 $t8
li $a2 6
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 7
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 8
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 9
jal printColorAtPosition
#b
li $a1 16
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 17
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 20
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 11
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 12
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 13
jal printColorAtPosition
li $a1 18
add $a1 $a1 $t8
li $a2 14
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 12
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 13
jal printColorAtPosition
li $a1 21
add $a1 $a1 $t8
li $a2 14
jal printColorAtPosition
li $a1 19
add $a1 $a1 $t8
li $a2 15
jal printColorAtPosition
li $a1 20
add $a1 $a1 $t8
li $a2 15
jal printColorAtPosition

#Attente + ecran noir
li $a0 200
jal sleepMillisec
jal resetAffichage
addi $t8 $t8 -1
j loopCredits # recommence la boucle en faisant monter d'une ligne les cr�dits

endCredits:
lw $ra ($sp)
addu $sp $sp 4
jr $ra


################################# reset ##################################

# initialise toutes les variables comme au debut
reset:
li $t0 1
sw $t0 tailleSnake
sw $t0 snakeDir

li $t0 0
sw $t0 snakePosX
sw $t0 snakePosY
sw $t0 numObstacles
sw $t0 scoreJeu

li $t0 460
sw $t0 speedSnake

j main
