const TITLES_A = [
    'Total', 'Maximum', 'High', 'Extreme', 'Lethal', 'Risky', 'Sticky', 'Deadly', 'Hyper',
    'Danger', 'Super', 'Frantic', 'Elevated', 'Steel', 'Dark', 'Absolute', 'Daring', 'Brutal',
    'Explosive', 'Ultimate', 'Raw', 'Double', 'Poisonous', 'Shocking', 'Furious', 'Destructive',
    'Vertical', 'Fierce', 'Primative', 'Vicious', 'Raging', 'Savage'
];

const TITLES_B = [
    'Voltage', 'Impact', 'Weapon', 'Assault', 'Seige', 'Proposition', 'Situation', 'Alliance',
    'Arena', 'Demolition', 'Death', 'Monkey', 'Risk', 'Destruction', 'Power', 'Deal', 'Escape',
    'Domination', 'Force', 'Strike', 'Attack', 'Invasion', 'Dragon', 'Turbulance', 'Limit', 'Rampage',
    'Outrage', 'Violence', 'Violation', 'Contact', 'Kick', 'Fight', 'Man'
];

const SUBTITLES = [
    'of Death', 'of Fury', 'of Danger', 'of Pain', 'from New York', 'from Hell', 'in Space',
    'from Outer Space', '"He\'s prefix"', '"It\'s prefix-tastic"', '"It\'s prefixific"',
    '...He did what he had to do', 'It\'s their last chance', 'of Wonder', 'from L.A.', 'part Deux', 'age of prefix'
];

const BACKGROUNDS = [
    'fire1.png', 'bomb1.png'
];

const ACTORS = [
    'bruce_willis.1.png', 'vin_diesel.1.png', 'sylvester_stallone.1.png', 'nicholas_cage.1.png', 'steven_segal.1.png'
];

const TEXT_COLORS = [
    '#CC0000', '#000000', 'blue', 'green'
];

function randomFrom(items) {
    return items[Math.floor(Math.random() * items.length)]
} 

function normalizeActorName(input) { 
    return input.split('.')[0]
        .split('_') 
        .map(n => n.substring(0, 1).toUpperCase() + n.substring(1))
        .join(' ');
}

export function generate() {
    const titleA = randomFrom(TITLES_A);
    const titleB = randomFrom(TITLES_B);
    const actorImage = randomFrom(ACTORS);
    const actorName = normalizeActorName(actorImage);
    const background = randomFrom(BACKGROUNDS);
    const textColor = randomFrom(TEXT_COLORS);
    let subtitle = '';

    if (Math.random() < 0.1) {
        subtitle = randomFrom(SUBTITLES).replace('prefix', titleA);
    }

    const poster = {
        title: titleA + ' ' + titleB,
        feature: '',
        subtitle: subtitle,
        actorImage: actorImage,
        actor: actorName,
        background: background,
        textColor: textColor,
    }

    return poster;
}