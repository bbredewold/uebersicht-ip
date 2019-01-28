/**
 * IP Widget for Übersicht
 * 
 * Version: 1.0
 * Last Updated: 01/28/2019
 * 
 * Created by Bert Bredewold
 */

// Get's WAN IP from a dig to OpenDNS
export const command = 'Milk/ip.sh';

// Refresh every X miliseconds
export const refreshFrequency = 10000;

// Base layout
export const className = {
    bottom: '5px',
    left: '5px',
    color: '#fff',
    fontFamily: 'Fira Code Retina',
    fontWeight: 100,
    fontSize: '12px'
}

// Render the widget
export const render = ({output, error}) => {
    if (output) {
        // Collect Interfaces from JSON
        const interfaces = JSON.parse(output).interfaces;

        // Map over the interfaces and construct table contents
        const items = interfaces.map((el) => {
            return (
                <tr key={el.iface}>
                    <td>{el.iface}: {el.address}</td>
                </tr>
            )
        });
    
        // Return the table
        return error ? (
            <div>Oops: <strong>{String(error)}</strong></div>
        ) : (
            <table>
                <tbody>
                    {items}
                </tbody>
            </table>
        );
    }
}