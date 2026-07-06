---
title: "L'énergie du train"
date: 2026-07-02
draft: false
image: image143.1.jpg
---

### ... et le vent qu'il provoque.

La première idée qui m'est venue lorsque j'ai confirmé que je ferais le développement de ce projet dans la vieille gare de St-Pascal a été de travailler avec l'énergie du train. Dès mon arrivée, j'ai commencé à travailler sur un artefact dont la fonction est de visualiser l'énergie de ce train qui passe en vacarme quelques fois par jour, faisant trembler l'édifice de la gare sur son passage, et dont l'absence, par contraste, plonge l'atelier dans un lieu de calme et d'un silence apparemment absolu.
Le développement de ce projet est échelonné sur toute la durée de la résidence et s'articule en parallèle avec le travail de recherche et d'exploration de la sculpture ou du processus de création de la maquette. Il y est relié indirectement et sert d'abord et avant tout à expérimenter avec une échelle de technologie applicable à l'échelle miniature. Ce projet fonctionne aussi comme « benchmark » pour expérimenter avec les principes d'autonomie énergétique.

#### Capturer l'énergie du train.

Dans un premier temps, j'ai créé une mini-éolienne munie de deux petits moteurs qui s'activent avec le mouvement de l'hélice pour produire deux sources de courant parallèles. J'ai accroché l'éolienne à un poteau de la clôture séparant le rail de l'atelier et j'y ai connecté un fil qui permet d'acheminer à l'intérieur de l'atelier le courant électrique produit.

![CAD du support moteur - rhino render ](image10.jpg)![Support moteur imprimé et monté sur carcasse de ventilateur ](image12.jpg)

![Support et emplacement ](image11.jpg).

Le fait de travailler d'une part avec le vent qui souffle quand bon lui semble et d'autre part avec un train qui passe sans ponctualité pendant quelques minutes et seulement quelques fois par jour est rapidement devenu un handicap pour le développement de mes apprentissages. J'ai donc compris qu'il était nécessaire de pouvoir simuler le vent. J'ai créé un socle me permettant d'activer mon éolienne à l'aide d'un ventilateur que j'ai muni d'une pédale de régulation de vitesse.
(photos et vidéos)

#### Support matériel et registre linéaire

J'ai utilisé une vieille trancheuse à papier comme structure de support du papier et j'y ai intégré un système de support pour le rouleau de papier à chacune des extrémités, ainsi qu'un moteur d'entraînement du papier et des composants électroniques de contrôle de vitesse et de mise en marche automatique lors du passage du train.
Pour alimenter ces composants, une deuxième génératrice éolienne de plus haut voltage a été fabriquée à partir d'un moteur recyclé d'un vieux tapis roulant.
Puis j'ai créé une structure de soutien pour trois stylos à laquelle j'ai rattaché un mini-moteur vibratoire alimenté par l'éolienne. Lorsque le vent souffle, l'hélice s'active, entraîne le moteur qui génère un courant électrique, lequel produit une vibration transmise aux stylos qui se mettent à dessiner le vent.

![Drawing machine](image143.6.jpg)


![Moteur papier](image143.2.jpg)![Ventilateur voltage 6-18v.](image143.13.jpg)![Moteur vibration](image143.4.jpg)![Support stylo](image143.5.jpg)

#### Capteur de vibration

Il arrive que le vent qui active l'éolienne provienne de l'ambiance et non directement du passage du train. Pour distinguer la source de vent provenant du train, j'ai créé un appareil capable de détecter la vibration de l'édifice causée par le passage du train. Il est composé d'un ressort de réveil-matin en spirale placé détendu à la verticale, et d'un circuit électrique doté d'une diode qui s'illumine au contact du ressort lorsqu'il entre en vibration.
![Vibration sensor 1](image143.10.jpg)

![Détail 1](image143.9.jpg)![Détail 2](image143.7.jpg)![Détail 3](image143.8.jpg)![Détail 4](image143.11.jpg)

#### L'encre et le papier

Lorsque la pointe des stylos est en contact avec le papier, l'encre s'écoule de façon continuelle, ce qui fait en sorte de consommer de l'encre inutilement. Pour remédier à cet inconvénient, j'ai imaginé un système de levier rattaché au mât de soutien de la structure de support des stylos. J'ai d'abord fait des tests avec un solénoïde, mais la quantité de courant requise est trop élevée. J'ai donc opté pour intégrer un mini servo-moteur contrôlé par un circuit intégré de type 555 timer IC.
J'ai élaboré la théorie d'un tel système, car j'aurais aimé éviter d'avoir recours à un microcontrôleur, mais sans obtenir de succès malheureusement.

Mes conclusions me mènent à croire que, vu la fonctionnalité de cet élément dans le contexte global de mon projet, il sera plus efficace d'intégrer un microcontrôleur (Arduino, ESP32 ou Raspberry Pi Pico) comme interface de contrôle des interactions entre les différents composants.

Cet exercice me donne l'occasion de construire un workflow générique d'entrées et de sorties (inputs/outputs) qui servira éventuellement lors de la réalisation de la dimension fonctionnelle de la maquette.
