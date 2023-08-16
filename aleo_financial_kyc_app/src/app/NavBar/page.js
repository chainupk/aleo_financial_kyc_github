import * as React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import CssBaseline from '@mui/material/CssBaseline';
import Divider from '@mui/material/Divider';
import Drawer from '@mui/material/Drawer';
import IconButton from '@mui/material/IconButton';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import MenuIcon from '@mui/icons-material/Menu';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import { WalletMultiButton } from "@demox-labs/aleo-wallet-adapter-reactui";

const drawerWidth = 240;

function DrawerAppBar(props) {
  const { window, changeAppPage } = props;
  const [mobileOpen, setMobileOpen] = React.useState(false);

  const handleDrawerToggle = () => {
    setMobileOpen((prevState) => !prevState);
  };

  const container = window !== undefined ? () => window().document.body : undefined;

  return (
    <Box sx={{ display: 'flex', marginBottom: '0.5em' }}>
      <CssBaseline />
      <AppBar component="nav" >
        <Toolbar>
          {/* <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: 'none' } }}
          >
            <MenuIcon />
          </IconButton> */}
          {/* <Typography
            variant="h6"
            component="div"
            sx={{ flexGrow: 1, display: { xs: 'none', sm: 'block' } }}
          >
            ALEO FINANCIAL KYC
          </Typography> */}
            <Box sx={{ display: 'flex', justifyContent: 'space-between', width: '100%' }}>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                    <Typography
                        variant="h5"
                        noWrap
                        component="a"
                        href=""
                        sx={{
                            mr: 2,
                            fontFamily: 'monospace',
                            fontWeight: 700,
                            letterSpacing: '.3rem',
                            color: 'inherit',
                            textDecoration: 'none',
                        }}
                    >
                        ALEO FINANCIAL KYC
                    </Typography>
                        <Button variant='contained' onClick={()=> {
                          props.changeAppPage('approve_fi')
                        }} sx={{ p: 1 }}>
                            Approve FIs
                        </Button>
                        &nbsp;
                        <Button variant='contained' onClick={() => {
                          props.changeAppPage('create_fi')
                        }} sx={{ p: 1 }}>
                            Create FIs
                        </Button>&nbsp;
                        <Button variant='contained' onClick={() => {
                          props.changeAppPage('financial_info')
                        }} sx={{ p: 1 }}>
                            Financial Infos
                        </Button>&nbsp;
                </Box>
                <Box sx={{ display: 'flex', alignItems: 'center' }}>
                  <WalletMultiButton />
                </Box>
            </Box>
          {/* <Box sx={{ display: { xs: 'none', sm: 'block' } }}>
            <WalletMultiButton />
          </Box> */}
        </Toolbar>
      </AppBar>
    </Box>
  );
}

DrawerAppBar.propTypes = {
  /**
   * Injected by the documentation to work in an iframe.
   * You won't need it on your project.
   */
  window: PropTypes.func,
};

export default DrawerAppBar;