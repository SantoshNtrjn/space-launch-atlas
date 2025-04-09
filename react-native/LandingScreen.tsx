import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import BlueGradientButton from './BlueGradientButton';
import { useNavigation } from '@react-navigation/native';

const LandingScreen: React.FC = () => {
  const navigation = useNavigation();

  return (
    <LinearGradient
      colors={['#000', '#859DB7']}
      start={{x:0.60,y:0.40}}
      style={styles.container}
    >
      <View style={styles.titleContainer}>
        <Text style={styles.title}>Space Launch Atlas</Text>
        <Text style={styles.title2}>By SantoshNtrjn</Text>
      </View>
      <View style={styles.buttonContainer}>
        <BlueGradientButton
          onPress={() => navigation.navigate('LaunchList')}
          text="Get Started"
        />
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  titleContainer: {
    marginTop: '80%',
    alignItems: 'center',
  },
  title: {
    color: '#fff',
    fontSize: 32,
    fontWeight: 'bold',
  },
  title2: {
      color: '#fff',
      fontSize: 16,
    },
  buttonContainer: {
    position: 'absolute',
    bottom: 50,
    left: 0,
    right: 0,
    alignItems: 'center',
  },
});

export default LandingScreen;