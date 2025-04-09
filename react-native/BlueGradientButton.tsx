import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';

interface BlueGradientButtonProps {
  onPress: () => void;
  text: string;
}

const BlueGradientButton: React.FC<BlueGradientButtonProps> = ({ onPress, text }) => (
  <TouchableOpacity onPress={onPress}>
    <LinearGradient
      colors={['#00ffff', '#607d8b']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={styles.button}
    >
      <Text style={styles.buttonText}>{text}</Text>
    </LinearGradient>
  </TouchableOpacity>
);

const styles = StyleSheet.create({
  button: {
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 30,
    marginVertical: 16,
    marginHorizontal: 16,
  },
  buttonText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#fff',
    textAlign: 'center',
  },
});

export default BlueGradientButton;